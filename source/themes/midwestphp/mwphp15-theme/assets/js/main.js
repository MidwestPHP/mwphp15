jQuery.noConflict();

/*------------||
|| Navigation ||
||------------*/
function toggleNav() {
    jQuery('.menu-toggle').click(function() {

        var navWidth,
            mobileNavMenu = jQuery('.mobile-nav-menu'),
            pageWrapper = jQuery('.wrapper'),
            menuSpeed = 250;

        // Copy navigation to mobile once when needed, and move register button to top of list
        if (!mobileNavMenu.find('.menu').length > 0) {
            jQuery('.primary-nav').find('.menu').clone().appendTo('.mobile-nav-menu');
            mobileNavMenu.find('.register').prependTo(mobileNavMenu.find('.menu'));
        }

        // Show and hide navigation
        if (pageWrapper.hasClass('open')) {
            pageWrapper.removeClass('open').animate({left: '0', right: '0'}, menuSpeed);
            mobileNavMenu.removeClass('open');
        } else {
            navWidth = mobileNavMenu.width();
            pageWrapper.addClass('open').animate({left: '-'+navWidth+'px', right: navWidth+'px'}, menuSpeed);
            mobileNavMenu.addClass('open');
        }
    });
}

jQuery(function() {

    jQuery('body').removeClass('no-js').addClass('js');

    jQuery('.menu-toggle').on('click',toggleNav());

});

jQuery(window).load(function() {

});

jQuery(window).resize(function() {

});