class ChallengeGenerateAi
  LOCATION_ID = "us-central1"
  API_ENDPOINT = "us-central1-aiplatform.googleapis.com"
  MODEL_ID = "gemini-2.0-flash-exp"
  GENERATE_CONTENT_API = "streamGenerateContent"

  def self.call(prompt:)
    new.call(prompt:)
  end

  def call(prompt:)
    scope = "https://www.googleapis.com/auth/cloud-platform"
    credentials = Google::Auth.get_application_default(scope)
    access_token = credentials.fetch_access_token!["access_token"]

    # リクエストボディ（JSON形式）の内容
    payload = {
      contents: [
        {
          role: "user",
          parts: [
            {
              text: prompt
            }
          ]
        }
      ],
      systemInstruction: {
        parts: [
          {
            text: "* あなたはユーザーの成長を促進するAIです\n* ユーザーが入力した目標・タスクに対して、あなたはユーザーが着実に成長できるようなチャレンジを考えてください。\n* チャレンジは難易度low・medium・highの3段階で３つ生成してください\n* チャレンジはその人自身が達成できる内容で、今日1日で完了できる内容としてください。以下の形式のJSONを返してください。\n\n{\"challenge_1\": {\"level\": \"low\",\"title\": \"チャレンジタイトル\",\"content\": \"チャレンジ内容\"},\"challenge_2\": {\"level\": \"medium\",\"title\": \"チャレンジタイトル\",\"content\": \"チャレンジ内容\"},\"challenge_3\": {\"level\": \"high\",\"title\": \"チャレンジタイトル\",\"content\": \"チャレンジ内容\"}}\n\n余計なテキストは絶対に一切含めず、純粋なJSONのみで返してください。また、правильныйのようなロシア語に見えてしまいそうな単語は全て使わないで回答を生成してください。"
          }
        ]
      },
      generationConfig: {
        responseModalities: [ "TEXT" ],
        temperature: 1,
        maxOutputTokens: 8192,
        topP: 0.95
      },
      safetySettings: [
        { category: "HARM_CATEGORY_HATE_SPEECH", threshold: "OFF" },
        { category: "HARM_CATEGORY_DANGEROUS_CONTENT", threshold: "OFF" },
        { category: "HARM_CATEGORY_SEXUALLY_EXPLICIT", threshold: "OFF" },
        { category: "HARM_CATEGORY_HARASSMENT", threshold: "OFF" }
      ]
    }
    url = "https://#{API_ENDPOINT}/v1/projects/#{ENV["GCP_PROJECT_ID"]}/locations/#{LOCATION_ID}/publishers/google/models/#{MODEL_ID}:#{GENERATE_CONTENT_API}"

    # Faradayによる接続設定
    conn = Faraday.new(url:) do |f|
      f.request  :json    # リクエストボディをJSONに変換
      f.response :logger  # リクエスト/レスポンスのロギング（必要に応じて）
      f.adapter  Faraday.default_adapter
    end

    # POSTリクエスト送信
    response = conn.post do |req|
      req.headers["Content-Type"]  = "application/json"
      req.headers["Authorization"] = "Bearer #{access_token}"
      req.body = payload.to_json
    end

    prettify_response(response.body)
  end

  private

  def prettify_response(response_body)
    data = JSON.parse(response_body)

    # 各要素の "candidates" -> "content" -> "parts" -> "text" を収集して結合
    all_text = data.flat_map do |element|
      (element["candidates"] || []).flat_map do |candidate|
        (candidate.dig("content", "parts") || []).map { |part| part["text"] }
      end
    end.join

    # 不要なコードブロック等を除去
    all_text = all_text.gsub(/^```/, "").gsub(/```$/, "")
                        .gsub(/^json\n/, "")

    # 結合した文字列を JSON としてパース
    JSON.parse(all_text)
  end
end
