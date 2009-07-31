$(document).ready(function(){
  $('a.present_toggle').click(function() {
    if ($('div.present_slide').is(':hidden')) {
      $('div.potential_slide').hide();
      $('div.present_slide').show();
    }
  });

  $('a.potential_toggle').click(function() {
    if ($('div.potential_slide').is(':hidden')) {
      $('div.present_slide').hide();
      $('div.potential_slide').show();
    }
  });

  $('a.show_detail').click(function() {
    if ($('div.section_lines').is(':hidden')) {
      $('div.section_lines').show();
      $(this).text("less detail")
    } else {
      $('div.section_lines').hide();
      $(this).text("more detail")
    }
  });
});
