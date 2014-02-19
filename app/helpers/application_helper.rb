module ApplicationHelper
  def page_title(tt = nil)
    if tt.nil?
      @_page_title.nil? ? params[:action] : @_page_title
    else
      @_page_title = tt
    end
  end

  def section(ss)
    @_section = ss
  end

  def top_nav_item(text, path, extra = {})
    kk = ""
    if text == @_section || text == @_page_title
      kk = "active"
    end

    content_tag("li", link_to(text, path, extra), class: kk)
  end

  def show_flash_notices
    notices = []

    flash.each do |name, msg|
      case name
      when :alert
        notices << flash_notice("danger", msg)
      when :notice
        notices << flash_notice("success", msg)
      end
    end

    notices.flatten.join("")
  end

  def flash_notice(type, msg)
    if msg.class != Array
      msg = [msg]
    end

    msg.map do |mm|
      content_tag :div, :class => "alert alert-#{ type } alert-dismissable" do
        raw %Q{<button type="button" class="close" data-dismiss="alert" } +
        %Q{aria-hidden="true">&times;</button>\n#{mm}}
      end
    end
  end
end
