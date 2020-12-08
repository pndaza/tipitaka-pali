const body = document.querySelector('body');
    
body.addEventListener('click', function() {
    
    var sel = window.getSelection();
    var part_one = "";
    var part_two = "";
    var click_word = null;

    if (sel.isCollapsed) {
        //extend selection to backward until founding space
        //get one character before and after of cursor click
        sel.modify('extend', 'backward', 'character');
        var before_char = sel.toString();
        sel.modify('move', 'forward', 'character');
        sel.modify('extend', 'forward', 'character');
        var after_char = sel.toString();
        // check if space contains in one of them,
        // if not, user click on word
        if ( /\s/.test(before_char) || /\s/.test(after_char)) {
            //user does not click on word
            sel.removeAllRanges();
            ReadBookInterface.showHideBars();

        }
        else {
            //user click on word
            //collect the whole word
            part_one = sel.toString();
            while(! /\s/.test(part_one)){
                sel.modify('extend', 'backward', 'character');
                part_one = sel.toString();
            }
            part_one = part_one.trim();

            sel.modify('move', 'forward', 'character');

            //extend selection to forward until founding space
            sel.modify('extend', 'forward', 'character');
            part_two = sel.toString();

            while(! /\s/.test(part_two)){
                sel.modify('extend', 'forward', 'character');
                part_two = sel.toString();
            }
            part_two = part_two.trim();
            click_word = part_one + part_two;
    }
    }

    sel.removeAllRanges();
    // for callback
    if (click_word){
        Define.postMessage(click_word);
    }

});