/**
 * Created with JetBrains RubyMine.
 * User: RoyK
 * Date: 20/04/13
 * Time: 11:10
 * To change this template use File | Settings | File Templates.
 */
window.Paginator = function Paginator(container, current_page, total_pages) {
    var closeRange = 1;
    var farRange = 2;
    this.container = container;
    this.current_page = current_page;
    this.total_pages = total_pages;
    this.draw_pages = function draw_pages() {
        var last = "";
        var next = "";
        var closeBefore = "";
        var farBefore = "";
        var closeAfter = "";
        var farAfter = "";
        var current = "<li class='paginator-viewed' data-id='"+current_page+"' id='_paginator_page"+current_page+"'>"+current_page+"</li>";
        if (current_page!==1) {
            last = "<li data-id='"+(current_page-1)+"'  id='_paginator_previous'>← Previous</li>";
            var counter = closeRange;
            while (counter>0) {
                var page = current_page - counter;
                if (page>0) {
                    closeBefore += "<li data-id='"+page+"' id='_paginator_page"+page+"'>"+page+"</li>";
                }
                counter--;
            }
            if (current_page-farRange>farRange) {
                counter = 1;
                while (counter<(farRange+1)) {
                    farBefore += "<li data-id='"+page+"' id='_paginator_page"+counter+"'>"+counter+"</li>"
                    counter++;
                }
            }
        }
        if (current_page<total_pages) {
            next = "<li data-id='"+(current_page+1)+"' id='_paginator_next'>Next →</li>";
            var counter = 1;
            while (counter<closeRange+1) {
                var page = current_page + counter;
                if (page<=total_pages) {
                    closeAfter += "<li data-id='"+page+"' id='_paginator_page"+page+"'>"+page+"</li>";
                }
                counter++;
            }
            if (total_pages-current_page>farRange) {
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
    };
    this.next_page = function next_page() {
        current_page++;
        this.draw_pages();
    };
    this.draw_pages();
}

