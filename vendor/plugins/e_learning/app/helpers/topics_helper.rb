module TopicsHelper

  def nested_topics(topics)
    topics.map do |topic, sub_topics|
      render(topic) + content_tag(:div, nested_topics(sub_topics), :class => "nested_topics")
    end.join.html_safe
  end

end
