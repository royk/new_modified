/**
 * Created with JetBrains RubyMine.
 * User: RoyK
 * Date: 20/04/13
 * Time: 11:10
 * To change this template use File | Settings | File Templates.
 */
window.Paginator = function Paginator(container, current_page, total_pages, loadURL) {
    var closeRange = 1;
    var farRange = 2;
    var loadURL = loadURL;
    this.container = container;
    this.current_page = current_page;
    this.total_pages = total_pages;
    var first_active_page = current_page;
    var last_active_page = current_page;
    this.draw_pages = function draw_pages() {
        var last = "";
        var next = "";
        var closeBefore = "";
        var farBefore = "";
        var closeAfter = "";
        var farAfter = "";
        var current = "";
        for (var i=first_active_page; i<last_active_page+1; i++) {
            current += "<li class='paginator-viewed' data-id='"+i+"' id='_paginator_page"+i+"'>"+i+"</li>";
        }
        if (first_active_page!==1) {
            last = "<li data-id='"+(first_active_page-1)+"'  id='_paginator_previous'>← Previous</li>";
            var counter = closeRange;
            while (counter>0) {
                var page = first_active_page - counter;
                if (page>0) {
                    closeBefore += "<li data-id='"+page+"' id='_paginator_page"+page+"'>"+page+"</li>";
                }
                counter--;
            }
            if (first_active_page-farRange>farRange) {
                counter = 1;
                while (counter<(farRange+1)) {
                    farBefore += "<li data-id='"+page+"' id='_paginator_page"+counter+"'>"+counter+"</li>"
                    counter++;
                }
            }
        }
        if (last_active_page<total_pages) {
            next = "<li data-id='"+(last_active_page+1)+"' id='_paginator_next'>Next →</li>";
            var counter = 1;
            while (counter<closeRange+1) {
                var page = last_active_page + counter;
                if (page<=total_pages) {
                    closeAfter += "<li data-id='"+page+"' id='_paginator_page"+page+"'>"+page+"</li>";
                }
                counter++;
            }
            if (total_pages-last_active_page>farRange) {
                counter = farRange;
                while (counter>0) {
                    var page = total_pages - counter + 1;
                    farAfter += "<li data-id='"+page+"' id='_paginator_page"+page+"'>"+page+"</li>";
                    counter--;
                }
            }

        }

        var finalHTML = last+farBefore+closeBefore+current+closeAfter+farAfter+next;
        $(container).html("<ul class='paginator'>"+finalHTML+"</ul>");
        $(container).children().children().not(".paginator-viewed").click(function() {
            var page_number = $(this).data("id");
            window.location.href = loadURL + page_number;
        });
    };
    this.next_page = function next_page() {
        last_active_page++;
        this.draw_pages();
    };
    if (total_pages>1) {
        this.draw_pages();
    }
}

