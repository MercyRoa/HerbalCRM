// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require aloha-config
//= require twitter/bootstrap
//= require_tree .
//= require chosen-jquery
//= require jquery-ui-timepicker/timepicker
//= require bootstrap-modalmanager
//= require bootstrap-modal
//= require jquery.bootstrap-growl


// Global search autocomplete...
$(function(){
    $(".chzn-select").chosen();

    // main search form
    //http://herbalcrm.dev/leads?utf8=%E2%9C%93&wf_match=any&wf_c0=email&wf_o0=contains&wf_v0_0=arnold&wf_c1=first_name&wf_o1=contains&wf_v1_0=arnold
    $('#mainSearch').submit(function(ev){
        ev.preventDefault();
        value = encodeURIComponent($('#global-search').val());
        if(!!!value){
            alert("Please insert a search term");
            return false;
        }
        window.location = '/leads?utf8=%E2%9C%93&wf_match=any&wf_c0=email&wf_o0=contains&wf_v0_0='+value+'&wf_c1=first_name&wf_o1=contains&wf_v1_0='+value
        //document.location.href='/newpage/';
    })

    var availableTags = ["ActionScript", "AppleScript", "Asp", "BASIC", "C", "C++", "Clojure", "COBOL", "ColdFusion", "Erlang", "Fortran", "Groovy", "Haskell", "Java", "JavaScript", "Lisp", "Perl", "PHP", "Python", "Ruby", "Scala", "Scheme"];
    $("#global-search").autocomplete({
        source: availableTags
    });

    //fix to bootstrap menu on ipad
    $('body')
        .on('touchstart.dropdown', '.dropdown-menu', function (e) { e.stopPropagation(); })
        .on('touchstart.dropdown', '.dropdown-submenu', function (e) { e.preventDefault(); });
});

function insertTextAtCursor(text) {
    var sel, range, html;
    if (window.getSelection) {
        sel = window.getSelection();
        if (sel.getRangeAt && sel.rangeCount) {
            range = sel.getRangeAt(0);
            range.deleteContents();
            range.insertNode( document.createTextNode(text) );
        }
    } else if (document.selection && document.selection.createRange) {
        document.selection.createRange().text = text;
    }
}
//
function insertHtmlAtCursor(html, $elem) {
    var sel, range;
    if (window.getSelection) {
        // IE9 and non-IE
        sel = window.getSelection();
        node = sel.anchorNode
        if($(node).parents('.aloha-editable').length == 0){
            $elem.focusToEnd();
        }

        if (sel.getRangeAt && sel.rangeCount) {
            range = sel.getRangeAt(0);
            range.deleteContents();

            // Range.createContextualFragment() would be useful here but is
            // non-standard and not supported in all browsers (IE9, for one)
            var el = document.createElement("div");
            el.innerHTML = html;
            var frag = document.createDocumentFragment(), node, lastNode;
            while ( (node = el.firstChild) ) {
                lastNode = frag.appendChild(node);
            }
            range.insertNode(frag);

            // Preserve the selection
            if (lastNode) {
                range = range.cloneRange();
                range.setStartAfter(lastNode);
                range.collapse(true);
                sel.removeAllRanges();
                sel.addRange(range);
            }else{
                console.log('hahbla');
                sel.collapseToEnd();
            }
        }
    } else if (document.selection && document.selection.type != "Control") {
        // IE < 9
        document.selection.createRange().pasteHTML(html);
    }
}

// Only for aloha
$.fn.focusToEnd = function() {
    return this.each(function() {
        var el = $(this).find(':last').get()[0];

        if(!!!el){
            el = $(this).append($('<span></span>')).find(':last').get()[0];
        }

        var range = document.createRange();
        var sel = window.getSelection();
        //range.setStart(el.childNodes[0], 1);
        //range.selectNode(el);
        range.setStartAfter(el);
        range.collapse(true);
        sel.removeAllRanges();
        sel.addRange(range);
        el.focus();
    });
};

function clearSelection(){
    if (window.getSelection) {
        if (window.getSelection().empty) {  // Chrome
            window.getSelection().empty();
        } else if (window.getSelection().removeAllRanges) {  // Firefox
            window.getSelection().removeAllRanges();
        }
    } else if (document.selection) {  // IE?
        document.selection.empty();
    }
}