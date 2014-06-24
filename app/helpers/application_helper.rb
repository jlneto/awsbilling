module ApplicationHelper
  def current_month
    Date.today.strftime('%B %Y')
  end

  def format_date(date)
    date.strftime("%d/%m/%y") if date
  end

  def format_datetime(date)
    date.localtime.strftime("%d/%m/%Y, %H:%M h") if date
  end

  def format_time(time)
    time.localtime.strftime("%H:%M:%S") if time
  end

  def format_number(number)
    number_with_delimiter(number, :separator => ",", :delimiter => ".") if number
  end

  def format_currency(number)
    number_to_currency(number, :separator => ",", :delimiter => ".") if number
  end

  def format_email(email)
    email.split('@')[0]
  end

  def format_variation(value)
    perc_class = ''
    if value
      if value >= 0
        perc_class = 'perc-increase glyphicon glyphicon-arrow-up'
      else
        perc_class = 'perc-decrease glyphicon glyphicon-arrow-down'
      end
      content_tag('span', "#{format_number(value.abs)}%", class: perc_class)
    end
  end

end
