html_tag(:div, 'something amazing') +
  html_tag(:div, 'something amazing', data: { enabled: true }) +
  html_tag(:div, 'something amazing', default: true) +
  html_tag(:div) { 'Hello World' } +
  html_tag(:div) { 'Goodbye Humanity' }