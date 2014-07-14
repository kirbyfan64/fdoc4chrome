fdoc4chrome
===========

View fdoc files in Google Chrome.

Building
********

You need `CoffeeScript <http://coffeescript.org/>`_ installed. Just run::

   cake build

to build.

Installation
************

- Go to `chrome://extensions`
- Check the `Developer Mode` check box
- Click `Load unpacked extension`
- Browse to the fdoc4chrome folder
- Click `Open`

Now, viewing fdoc files in Chrome renders them as HTML.

Updating
********

Run::
   
   cake build

again to update the JavaScript file.

Then:

- Go to `chrome://extensions`
- Under `fdoc4chrome`, click `Reload extension`

Todo:
*****

- Add syntax highlighting
- Upload .crx file and add to Chrome web store
