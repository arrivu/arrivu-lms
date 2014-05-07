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

    });
});