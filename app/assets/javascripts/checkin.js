function RefreshCheckinButton() {

    var submitButton = $('#CheckInSubmit');
    var statusSelect = $('select#_checkin_status_id');
    var commentField = $('#CheckInForm input[name=comment]');

    if (!statusSelect.val() || statusSelect.val() <= 0) {
        submitButton.attr("value","Select Availability!");
        submitButton.attr("disabled","disabled");
    }
    else if (commentField.val().length > 140) {
        submitButton.attr("value","Comment Is Too Long!");
        submitButton.attr("disabled","disabled");
    }
    else{
        submitButton.attr("value","Check In!");
        submitButton.removeAttr("disabled");
    }
}

$(document).ready(function() {

    $('#CheckInCancel').on("click", function() {
        $('#CheckInDialog').modal('hide');
    });


    $('select#_checkin_status_id').change(function() {
        RefreshCheckinButton();
    });


    $('#CheckInForm').on("submit", function()
    {
        hideCurrentCheckInComment()

        var selected_services = [];
        $('#CheckInForm input[type=checkbox]').each(function()
        {
            if ($(this).is(':checked')) selected_services.push($(this).attr("id"));
        })

        $.cookie('checkin_services', JSON.stringify(selected_services));

        var submitButton = $('#CheckInSubmit');
        //submitButton.hide();
        submitButton.attr("value","Please Wait");
        submitButton.attr("disabled","disabled");

        $('#CheckInCancel').attr("disabled","disabled");
        
        var values = $(this).serialize();
        $.post("/checkin.json", values,
            function(data){
                $('#CheckInDialog').modal('hide');
                showFlashNotice( "Thanks for checking in!" );
                $('#CheckedInMembers .avatar').remove();
                $('#CheckInCancel').removeAttr("disabled");
                UpdateDaypassBalance();
                //submitButton.show();
                
                submitButton.removeAttr("disabled");
                submitButton.attr("value","Check In");  

                showCheckedInMembers(data.user_id);
        });

        return false;   
    });

    
    $('.CheckInLink').on("click", function(evt) { 
        evt.stopPropagation();
        startCheckIn(); 
    });


    $('#CheckOutLink').on( "click", function(evt)
    {
        evt.stopPropagation();
        //if (confirm("WARNING: If you check back in later on the same day after checking out, your day pass balance will be deducted!"))
        {
            var link = $(this);
            $.get("/checkout", function(data)
            {
                showCheckedInMembers(data.user_id);
            });
        }
        return false;

    });

});

function startCheckIn()
{
    $.get("/authentications/index.js", function(data)
    {
        $('li.checkinoption').hide();

        auths = eval(data);
        for (var i = 0; i < auths.length; i++)
        {
            var svc = auths[i].provider;
            if (svc != "google_oauth2")
            {
                $('li.' + svc).show();
                $('li.' + svc + ' input#checkin-' + svc).attr("checked",auths[i].checkin?"checked":null);
            }
        }

        RefreshCheckinButton();
        var dialog = $('#CheckInDialog');
        dialog.modal('show');
    });

    return false;
}


function distance(lat1,lon1,lat2,lon2) {
   var R = 6371000; // meters
   var dLat = (lat2-lat1) * Math.PI / 180;
   var dLon = (lon2-lon1) * Math.PI / 180;
   var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
   Math.cos(lat1 * Math.PI / 180 ) * Math.cos(lat2 * Math.PI / 180 ) *
   Math.sin(dLon/2) * Math.sin(dLon/2);
   var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
   var d = R * c;
   return Math.round(d);
}

function checkLocation(lat,lng)
{
    if (navigator.geolocation && lat != 0 && lng != 0) 
    {
        navigator.geolocation.getCurrentPosition(function(position) {

            var dist = distance(lat, lng, position.coords.latitude, position.coords.longitude);
            if (100 > dist)
            {
                $('input.CheckInLink').attr("value","Check In!");
                $('.CheckInLink').on("click", function() { startCheckIn(); });
            }
            else
            {
                $('input.CheckInLink').attr("value","You are too far away to check in! (" + dist + "m)");
                $('input.CheckInLink').off("click");
            }
            $('#GeoInfo').html("You are currently " + dist + "m away from the space.")
        });
    }
    else
    {
        $('input.CheckInLink').attr("value","Check In!");
        
    }    
}


var currentComment = -1;
var commentTimer = 0;

function hideCurrentCheckInComment()
{
    clearTimeout(commentTimer);
    var prev = $('.avatarComment:nth('+currentComment+')');
    if (prev) prev.hide();
}

function showNextCheckInComment()
{
    hideCurrentCheckInComment();

    var nextShowing = 10000;

    currentComment++;
    if (currentComment >= $('.avatarComment').length)
    {
        nextShowing *= 2;
        currentComment = -1;
    }
    else
    {
        var next = $('.avatarComment:nth('+currentComment+')');
        if (next) next.fadeIn("slow");
    }
    commentTimer = setTimeout(function() { showNextCheckInComment(); }, nextShowing);    
}

function showCheckedInMembers(currentUserId)
{
    //var div = $('div#CheckedInMembers');
    //if (div)
    {
        $.get('/checkedin', {}, function(data, textStatus, jqXHR)
        {
            clearTimeout(commentTimer);
            $("div.nomembers").remove();
            $("div.avatarWrapper").fadeOut();

            var div = $('div#CheckedInMembers');
            var currentUserCheckedIn = false;

            if (data.checkins.length <= 0)
            {
                if (div)
                    div.append("<div class='nomembers'><em>No members are currently checked in.</em></div>");
            }
            else
            {
                for (i = 0; i < data.checkins.length; i++)
                {
                    var checkin = data.checkins[i];
                    if (currentUserId && (currentUserId == checkin.user.id))
                        currentUserCheckedIn = true;

                    if (div)
                    {
                      var avatarWrapper = $("<div id='user-"+checkin.user.id+"' class='avatarWrapper'></div>");
                      var checkInComment= $("<div class='avatarComment'>" + checkin.comment + "</div>");

                      var avatarStatus  = $("<div class='avatar status"+checkin.checkin_status_id+"'></div>");
                      avatarStatus.append("<img src='/avatar/"+checkin.user.id+"'>");
                      avatarStatus.append("<span class='avatarName'>"+checkin.user.name+"</span>");

                      avatarWrapper.append(checkInComment);
                      avatarWrapper.append(avatarStatus);
                     
                      div.append(avatarWrapper);
                      avatarWrapper.fadeIn("slow");
                    }
                }

            }

            if (currentUserCheckedIn)
            {
                $("a.CheckInLink").text("Change Status");
                $("div.CheckInLink").hide();
                $("#CheckOutLink").parent().fadeIn();
            }
            else
            {
                $("a.CheckInLink").text("Check In");
                $("div.CheckInLink").show();
                $("#CheckOutLink").parent().hide();   
            }
            
            if (div)
                setTimeout(function() { showNextCheckInComment(); }, 3000);

         }, "json");

    }
}