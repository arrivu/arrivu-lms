define('dashboard/jst/gradereport/column_header', ["compiled/handlebars_helpers","i18n!gradereport.column_header"], function (Handlebars) {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
  templates['gradereport/column_header'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, helper, options, helperMissing=helpers.helperMissing, self=this, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    title=\"";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.column_header")
  },data:data},helper ? helper.call(depth0, "this_assignment_is_muted", "This assignment is muted", options) : helperMissing.call(depth0, "t", "this_assignment_is_muted", "This assignment is muted", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"\n  ";
  return buffer;
  }

function program3(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n    title=\"";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.column_header")
  },data:data},helper ? helper.call(depth0, "zero_point_assignment", "Assignments in this group have no points possible and cannot be included in grade calculation", options) : helperMissing.call(depth0, "t", "zero_point_assignment", "Assignments in this group have no points possible and cannot be included in grade calculation", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"\n  ";
  return buffer;
  }

function program5(depth0,data) {
  
  
  return "muted";
  }

function program7(depth0,data) {
  
  
  return "\n    <i class=\"icon-warning\"></i>\n  ";
  }

function program9(depth0,data) {
  
  var buffer = "", stack1, helper, options;
  buffer += "\n  <div class='assignment-points-possible'>\n    ";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.column_header")
  },data:data},helper ? helper.call(depth0, "points_out_of", "Out of %{assignment.points_possible}", options) : helperMissing.call(depth0, "t", "points_out_of", "Out of %{assignment.points_possible}", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  </div>\n";
  return buffer;
  }

  buffer += "<a\n  ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.assignment)),stack1 == null || stack1 === false ? stack1 : stack1.muted), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.assignment)),stack1 == null || stack1 === false ? stack1 : stack1.invalid), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  class=\"assignment-name ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.assignment)),stack1 == null || stack1 === false ? stack1 : stack1.muted), {hash:{},inverse:self.noop,fn:self.program(5, program5, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"\n  href=\"";
  if (helper = helpers.href) { stack1 = helper.call(depth0, {hash:{},data:data}); }
  else { helper = (depth0 && depth0.href); stack1 = typeof helper === functionType ? helper.call(depth0, {hash:{},data:data}) : helper; }
  buffer += escapeExpression(stack1)
    + "\"\n>\n  ";
  stack1 = helpers['if'].call(depth0, ((stack1 = (depth0 && depth0.assignment)),stack1 == null || stack1 === false ? stack1 : stack1.invalid), {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n  ";
  stack1 = ((stack1 = ((stack1 = (depth0 && depth0.assignment)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</a>\n<a class=\"gradebook-header-drop assignment_header_drop\" data-assignment-id=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.assignment)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" href=\"#\" role=\"button\">\n  ";
  stack1 = (helper = helpers.t || (depth0 && depth0.t),options={hash:{
    'scope': ("gradereport.column_header")
  },data:data},helper ? helper.call(depth0, "assignment_options", "Assignment Options", options) : helperMissing.call(depth0, "t", "assignment_options", "Assignment Options", options));
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</a>\n";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.showPointsPossible), {hash:{},inverse:self.noop,fn:self.program(9, program9, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });
  
  
  return templates['gradereport/column_header'];
});
