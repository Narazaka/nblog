article_form_tags = ->
	tag_list = $('#article_tag_list')
	tag_click = ->
		tag = $(@).find('.name').text()
		tags = tag_list.val().split(/,\s*/i).filter((tag) => tag != '')
		if -1 == tags.indexOf tag
			tags.push tag
		tag_list.val tags.join ', '
	$('.tags li').each (li) ->
		$li = $(@)
		if 0 == $li.find('a').length
			$li.unbind('click')
			$li.bind('click', tag_click)
$(document).ready article_form_tags
$(document).on 'page:load', article_form_tags
