module ApplicationHelper
    def markdown(text)
        return '' if text.blank?

        renderer = Redcarpet::Render::HTML.new(
        filter_html: true,  # odrzuca raw‑HTML
        hard_wrap:   true
        )
        extensions = {
        autolink:           true,
        fenced_code_blocks: true,
        tables:             true,
        strikethrough:      true
        }

        Redcarpet::Markdown.new(renderer, extensions)
                    .render(text)
                    .html_safe
    end

    
  # Regex wykrywający podstawowe elementy Markdown
MARKDOWN_DETECTOR = %r{
    (```[\s\S]*?```)|       # code block fenced
    (`[^`]+`)|               # inline code
    (\*\*[^*]+\*\*)|     # bold **
    (\*[^*]+\*)|           # italic *
    (_[^_]+_)|               # italic _
    (?:^|\W)([-*]\s)|       # lista wypunktowana
    (?:^|\W)(\d+\.\s)|    # lista numerowana
    (\[[^\]]+\]\([^\)]+\))  # link [text](url)
  }mix
  # Główny renderer odpowiedzi ChatGPT
  def render_chatgpt(raw_text)
    return '' if raw_text.blank?

    if raw_text.match?(MARKDOWN_DETECTOR)
      # Jeżeli wykryliśmy Markdown — renderujemy na HTML
      markdown(raw_text)
    else
      # Czysty tekst → escapujemy + simple_format (<>p + <br>)
      simple_format(h(raw_text))
    end
  end

end
