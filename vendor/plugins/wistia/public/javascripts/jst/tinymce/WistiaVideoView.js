define('wistia/jst/tinymce/WistiaVideoView', ["compiled/handlebars_helpers","i18n!tinymce.wistia_video_view"], function (Handlebars) {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
  templates['tinymce/WistiaVideoView'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, stack3, stack4, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0;


  buffer += "<div class=\"insertUpdateImage bootstrap-form form-horizontal\" >\n  <fieldset style=\"max-width: 597px;\">\n    <legend>";
  stack1 = "Image Source";
  stack2 = "image_source";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</legend>\n    <div class=\"ui-tabs-minimal imageSourceTabs\">\n      <ul>\n        <li><a href=\"#tabUrl\">";
  stack1 = "URL";
  stack2 = "url";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</a></li>\n        <li><a href=\"#tabUploaded\">";
  stack1 = "Canvas";
  stack2 = "canvas";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</a></li>\n        <li><a href=\"#tabFlickr\">";
  stack1 = "Flickr";
  stack2 = "flickr";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</a></li>\n      </ul>\n      <div id=\"tabUrl\">\n        <input type=\"url\"\n               name=\"image[src]\"\n               class=\"input-xxlarge\"\n               placeholder=\"http://example.com/image.png\"\n               style=\"margin-bottom: 20px;\">\n      </div>\n      <ul role=\"tree\" class=\"folderTree insertUpdateImageTabpane\" id=\"tabUploaded\"></ul>\n      <div id=\"tabFlickr\">\n\n      </div>\n    </div>\n  </fieldset>\n  <fieldset>\n    <legend>";
  stack1 = "Attributes";
  stack2 = "attributes";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</legend>\n    <div class=\"control-group\">\n      <label class=\"control-label\" for=\"image_alt\">";
  stack1 = "Alt text";
  stack2 = "alt_text";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</label>\n      <div class=\"controls\">\n        <input type=\"text\"\n               class=\"input-xlarge\"\n               name=\"image[alt]\"\n               id=\"image_alt\"\n               aria-describedby=\"alt_text_description\">\n        <span><p class=\"help-block\" id=\"alt_text_description\">";
  stack1 = "Describe the image to improve accessibility";
  stack2 = "alt_help_text";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</p></span>\n      </div>\n    </div>\n    <div class=\"control-group\">\n      <label class=\"control-label\" for=\"dimensions_controls\">";
  stack1 = "Dimensions";
  stack2 = "dimensions";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</label>\n      <div class=\"controls\" id=\"dimensions_controls\" aria-describedby=\"aspect_ratio_note\">\n        <input class=\"span1\"\n               name=\"image[width]\"\n               type=\"text\"\n               aria-label=\"";
  stack1 = "Image Width";
  stack2 = "image_width";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n        x\n        <input class=\"span1\"\n               name=\"image[height]\"\n               type=\"text\"\n               aria-label=\"";
  stack1 = "Image Height";
  stack2 = "image_height";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\">\n      <span><p class=\"help-block\" id=\"aspect_ratio_note\">";
  stack1 = "Aspect ratio will be preserved";
  stack2 = "dimension_help_text";
  stack3 = {};
  stack4 = "tinymce.wistia_video_view";
  stack3['scope'] = stack4;
  foundHelper = helpers['t'];
  stack4 = foundHelper || depth0['t'];
  tmp1 = {};
  tmp1.hash = stack3;
  if(typeof stack4 === functionType) { stack1 = stack4.call(depth0, stack2, stack1, tmp1); }
  else if(stack4=== undef) { stack1 = helperMissing.call(depth0, "t", stack2, stack1, tmp1); }
  else { stack1 = stack4; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</p></span>\n      </div>\n    </div>\n  </fieldset>\n</div>\n";
  return buffer;});
  
  
  return templates['tinymce/WistiaVideoView'];
});
