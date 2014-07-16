
function showFlashNotice( message )
{
    $('div.flash.notice_js p').html(message)
    $('div.flash.notice_js').fadeIn("fast", function() { fadeOutFlashMessages(); });
}

function fadeOutFlashMessages() {
    $('div.flash').not('.nofade').each(function()
    {
        $(this).delay(4000).fadeOut("fast", function() { $(this).hide(); });
    });
}

function UpdateDaypassBalance() {

	$.get('/daypass_balance.json', {}, function(data, textStatus, jqXHR)
    {
    	if (data.daypass_balance > 0) {
    		$('#DaypassBalance').html(data.daypass_balance);
    		$('#HasDayPasses').fadeIn();
    		$('#NoDayPasses').hide();
    	} else {
    		$('#HasDayPasses').hide();
    		$('#NoDayPasses').fadeIn();
    	}
    });
}


function refreshMembershipOptions() {
    
  if ($('#user_membership_id').length == 0)
        return;
  
  $.get('/membership_options.json',{},
      function(data, textStatus, jqXHR) {

        $('#user_membership_id').empty();

        $.each(data.options, function(key, val) {   
             $('#user_membership_id')
                  .append($('<option>', { value : key })
                  .text(val)); 
        });

        $('#user_membership_id').val(data.current);

      });
}


$(document).ready(function() {
    fadeOutFlashMessages();
    UpdateDaypassBalance();
});
