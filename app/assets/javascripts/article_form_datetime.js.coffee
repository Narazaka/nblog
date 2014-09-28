article_form_datetime = ->
	$('[type="datetime"]').datetimepicker
		lang: 'ja'
		i18n:
			ja:
				months: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
				dayOfWeek: ['日', '月', '火', '水', '木', '金', '土']
		format: 'Y-m-d H:i'
$(document).ready article_form_datetime
$(document).on 'page:load', article_form_datetime
