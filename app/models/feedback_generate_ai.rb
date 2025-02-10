class FeedbackGenerateAi
  PROJECT_ID = "zenn-ai-agent-hackathon-449013"
  LOCATION_ID = "us-central1"
  API_ENDPOINT = "us-central1-aiplatform.googleapis.com"
  MODEL_ID = "gemini-2.0-flash-exp"
  GENERATE_CONTENT_API = "streamGenerateContent"

  def self.call(prompt:, mentor:)
    new.call(prompt:, mentor:)
  end

  def call(prompt:, mentor:)
    scope = "https://www.googleapis.com/auth/cloud-platform"
    credentials = Google::Auth.get_application_default(scope)
    access_token = credentials.fetch_access_token!["access_token"]

    system_instruction = <<~SYSTEM_INSTRUCTION
      あなたは#{mentor}です。#{mentor}に成り切ったつもりで、ユーザーのチャレンジの達成状況やコメントに対して、フィードバックを行なってください。
      またユーザーに向けて、明日以降もチャレンジを継続できるようなアドバイスをお願いします。

      ## ルール
      - チャレンジの達成状況について、ユーザーは【good】や【bad】といった自己評価を行いますが、【good】や【bad】といった表現はそのまま使わず日本語に置き換えてください（墨カッコは不要です）
      - また、правильныйのようなロシア語に見えてしまいそうな単語は全て使わないで回答を生成してください。
      - メッセージはマークダウン記法は使わず、テキストのみで構成してください。
    SYSTEM_INSTRUCTION
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
            text: system_instruction
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
    url = "https://#{API_ENDPOINT}/v1/projects/#{PROJECT_ID}/locations/#{LOCATION_ID}/publishers/google/models/#{MODEL_ID}:#{GENERATE_CONTENT_API}"

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

    data.flat_map do |element|
      (element["candidates"] || []).flat_map do |candidate|
        (candidate.dig("content", "parts") || []).map { |part| part["text"] }
      end
    end.join
  end
end
