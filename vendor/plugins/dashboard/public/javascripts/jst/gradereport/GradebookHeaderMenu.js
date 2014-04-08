define('dashboard/jst/gradereport/GradebookHeaderMenu', ["compiled/handlebars_helpers","i18n!gradereport.gradebook_header_menu"], function (Handlebars) {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
  templates['gradereport/GradebookHeaderMenu'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, functionType="function", escapeExpression=this.escapeExpression, helperMissing=helpers.helperMissing, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    <li><a href=\"";
  if (helper = helpers.speedGraderUrl) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.speedGraderUrl); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.gradebook_header_menu")
  },data:data},helper ? helper.call(depth0, "speedgrader", "SpeedGrader", options) : helperMissing.call(depth0, "t", "speedgrader", "SpeedGrader", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</a></li>\n  ";
  return buffer;
  }

  buffer += "<ul class=\"gradebook-header-menu\">\n  <li><a data-action=\"showAssignmentDetails\" href=\"";
  if (helper = helpers.assignmentUrl) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.assignmentUrl); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\">";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.gradebook_header_menu")
  },data:data},helper ? helper.call(depth0, "assignment_details", "Assignment Details", options) : helperMissing.call(depth0, "t", "assignment_details", "Assignment Details", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</a></li>\n  ";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.speedGraderUrl), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  <li><a data-action=\"messageStudentsWho\" href=\"#\">";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.gradebook_header_menu")
  },data:data},helper ? helper.call(depth0, "message_students_who", "Message Students Who...", options) : helperMissing.call(depth0, "t", "message_students_who", "Message Students Who...", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</a></li>\n  <li><a data-action=\"setDefaultGrade\" href=\"#\">";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.gradebook_header_menu")
  },data:data},helper ? helper.call(depth0, "set_default_grade", "Set Default Grade", options) : helperMissing.call(depth0, "t", "set_default_grade", "Set Default Grade", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</a></li>\n  <li><a data-action=\"curveGrades\" href=\"#\">";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.gradebook_header_menu")
  },data:data},helper ? helper.call(depth0, "curve_grades", "Curve Grades", options) : helperMissing.call(depth0, "t", "curve_grades", "Curve Grades", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</a></li>\n  <li><a data-action=\"downloadSubmissions\" href=\"#\">";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.gradebook_header_menu")
  },data:data},helper ? helper.call(depth0, "download_submissions", "Download Submissions", options) : helperMissing.call(depth0, "t", "download_submissions", "Download Submissions", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</a></li>\n  <li><a data-action=\"reuploadSubmissions\" href=\"#\">";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.gradebook_header_menu")
  },data:data},helper ? helper.call(depth0, "re_upload_submissions", "Re-Upload Submissions", options) : helperMissing.call(depth0, "t", "re_upload_submissions", "Re-Upload Submissions", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</a></li>\n  <li><a data-action=\"toggleMuting\" href=\"#\"></a></li>\n</ul>\n";
  return buffer;
  });
  
  
  return templates['gradereport/GradebookHeaderMenu'];
});
