define([
    'jquery' /* $ */,
    'jqueryui/jquery.jcontent.0.8',
    'jqueryui/jquery.easing.1.3'
], function($) {
    $("document").ready(function(){
        $("div#demo1").jContent({orientation: 'horizontal',
            easing: 'easeOutCirc',
            duration: 500,
            auto: true,
            direction: 'next', //or 'prev'
            pause: 1500,
            pause_on_hover: true});

        $("div#demo2").jContent({orientation: 'horizontal',
            easing: 'easeOutCirc',
            duration: 500,
            auto: true,
            direction: 'next', //or 'prev'
            pause: 1500,
            pause_on_hover: true});

        if ($("#popular_course_div").find("#popular_course_on_index_page").length == 0)
            $("#popular_course_banner").hide();
            $(".browseourcoursessmall").hide();

        $("div.author_slider_index_view").jContent({orientation: 'horizontal',
            easing: 'easeOutCirc',
            duration: 500,
            direction: 'next', //or 'prev'
            width:229,
            circle: true,
            height:46});

    });
});