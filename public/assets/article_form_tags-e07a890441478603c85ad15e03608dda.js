(function() {
  var article_form_tags;

  article_form_tags = function() {
    var tag_click, tag_list;
    tag_list = $('#article_tag_list');
    tag_click = function() {
      var tag, tags;
      tag = $(this).find('.name').text();
      tags = tag_list.val().split(/,\s*/i).filter((function(_this) {
        return function(tag) {
          return tag !== '';
        };
      })(this));
      if (-1 === tags.indexOf(tag)) {
        tags.push(tag);
      }
      return tag_list.val(tags.join(', '));
    };
    return $('.tags li').each(function(li) {
      var $li;
      $li = $(this);
      if (0 === $li.find('a').length) {
        $li.unbind('click');
        return $li.bind('click', tag_click);
      }
    });
  };

  $(document).ready(article_form_tags);

  $(document).on('page:load', article_form_tags);

}).call(this);
