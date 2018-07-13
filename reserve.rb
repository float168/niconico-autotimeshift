require_relative 'lib/nans'

tags = IO.readlines(File.expand_path('../tags.txt', __FILE__), chomp: true)
tags.each do |tag|
  res = Nans.niconico.search(tag, 1)
  res.each do |r|
    begin
      reserved = Nans.niconico.reserve(r.contentId)
      if reserved
        payload = {text: "タイムシフト予約完了",
          attachments: [
            {text: r.url}
          ]
        }
      else
        payload = {text: "タイムシフト予約に失敗しました",
          attachments: [
            {text: r.url}
          ]
        }
      end
      begin
        Nans.slack.post(payload)
      rescue => exception
        puts exception.message
      end
    rescue => exception
      puts exception.message
    end
  end
end
