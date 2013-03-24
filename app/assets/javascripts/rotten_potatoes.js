RP = {
    setup: function() {
        // construct new DOM elements
        $('<label for="filter" class="explanation">' +
          'Restrict to movies suitable for children' +
          '</label>' +
          '<input type="checkbox" id="filter"/>'
         ).insertBefore('#movies').change(RP.filter_adult);
    },
    filter_adult: function () {
        // 'this' is element that received event (checkbox)
        if ($(this).is(':checked')) {
            // replaced by server side 'adult' class
            //$('#movies tbody tr').each(RP.hide_if_adult_row);
            $('#movies tr.adult').hide();
        } else {
            $('#movies tbody tr').show();
        };
    }
    // replaced by server side 'adult' class
    //     },
    // hide_if_adult_row: function() {
    //   if (! /^G|PG$/i.test($(this).find('td:nth-child(2)').text())) {
    //       $(this).hide();
    //   }
    //     }
}
$(RP.setup);       // when document ready, run setup code

