document.addEventListener('click', function(e) {
    // e.preventDefault();

    var caret, range;
    if (document.caretRangeFromPoint) { // webkit/chrome
    // alert('browser is webkit');
        range = document.caretRangeFromPoint(e.clientX, e.clientY);
    } else if (document.caretPositionFromPoint) { // gecko/firefox
        caret = document.caretPositionFromPoint(e.clientX, e.clientY);
        range = document.createRange();
        range.setStart(caret.offsetNode, caret.offset); // DOM element and position
    }

    // get word
    if (range) { // chrome and firefox
        selection = window.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);
        // selection.modify('move', 'backward', 'word');
        // selection.modify('extend', 'forward', 'word');

        var part_one = "";
        var part_two = "";
        var click_word;
        part_one = selection.toString();
        
        while(! /\s/.test(part_one)){
            selection.modify('extend', 'backward', 'character');
            part_one = selection.toString();
        }
        part_one = part_one.trim();
        selection.modify('move', 'forward', 'character');

        //extend selection to forward until founding space
        selection.modify('extend', 'forward', 'character');
        part_two = selection.toString();

        while(! /\s/.test(part_two)){
            selection.modify('extend', 'forward', 'character');
            part_two = selection.toString();
        }
        part_two = part_two.trim();
        click_word = part_one + part_two;

        // alert(click_word);
        selection.removeAllRanges();
        // for callback
        if (click_word){
            Define.postMessage(click_word);
        }
        // Define.postMessage('ကုသလာ');
        selection.collapse(selection.anchorNode, 0);

    } else if (document.body.createTextRange) {
        // internet explorer
        // get word
        range = document.body.createTextRange();
        range.moveToPoint(event.clientX, event.clientY);
        range.select();
        range.expand('word');
        alert(range.text);
    }
}, false);