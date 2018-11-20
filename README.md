# Fcfinder

[![Gem Version](https://badge.fury.io/rb/fcfinder.svg)](http://badge.fury.io/rb/fcfinder)

Web File Manager For The Rails 
Integrated in ckeditor and TinyMCE with File Explorer you can use as a quick and simple way.

![Arayuzu](https://raw.githubusercontent.com/furkancelik/fcfinder/master/screenshots/fcfinder_interface.png)

## Requirements

###ImageMagick

[imagemagick](http://github.com)'in kurulu olması gerekmektedir.

For A Windows Installation;
[imagemagick](http://github.com) from the address the Download button 
Windows binary from the release area **compatible with ruby** (same as installed x86 x64)
ImageMagick -******-dll.exe download the file and you can install it in the installation process, make sure that is added to the PATH environment variable.

To The Command Line

`convert -version`

when you write in this way, you can see that you have successfully installed.

```
Version: ImageMagick 6.9.1-4 Q16 x86 2015-05-31 http://www.imagemagick.org
Copyright: Copyright (C) 1999-2015 ImageMagick Studio LLC
License: http://www.imagemagick.org/script/license.php
Features:  Cipher DPC Modules OpenMP
...
```

### Puma Server (Optional)
Requirement requirement but not Webrick large files can give a problem in the installation process.
the Puma for Windows installation [Here](https://github.com/hicknhack-software/rails-disco/wiki/Installing-puma-on-windows) you can look at.



## Setup

Gemfile for rails applications, you must add the following line to your file.

```ruby
gem 'fcfinder'
```

```
$ bundle install
```

with rails you can perform the installation process.


## Use


###Setting The Controller

```ruby
class YourController < ApplicationController

  def index
	if request.post?
	  # The bottom line is that only the logged in user (admin) can access the Finder
	  # The Session Name Must Be The Same As The Name You Use On Your System
	  # The Logon Process Will Be If You Can Remove This Line
	  if session[:user_id]
		# example file with the name you want under the terms you can create the public folder, 'uploads' was created in the form of
		# File.join(Rails.public_path, 'uploads', "/*")
		# Files you want to be listed as a parameter
		# server address,
		# post parameters,
		# Parameter Hash in the hash
		# :max_file_size = indicates the size of the file to be loaded (byte)
		# :allowed_mime = the file types that you want to allow extra
		# :disallowed_mime = disallowed file types
        render text: Fcfinder::Connector.new(File.join(Rails.public_path, 'uploads', "/*"), request.env["HTTP_HOST"], params[:fcfinder],
                                             {
                                                 :max_file_size => 1_000_000,
                                                 :allowed_mime => {'pdf' => 'application/pdf'},
                                                 :disallowed_mime => {}
                                             }).run, :layout => false
      # If Not Logged On
	  #( session[:user_id] if you must remove the else part of the if statement block is removed)
	  else
	  # if the value is null is blocking access session_id, keep your files safe.
        render :text => "Access not allowed!".to_json, :layout => false
      end
    else
      render :layout => false
    end
  end


  #to download the file
  def download
	# 'uploads' folder under the public folder part again.
    send_file File.join(Rails.public_path,'uploads',params[:path].split(":").join("/")+"."+params[:format])
  end
end
```

###Route Setting

```ruby
scope '/fcfinder' do
  match '/', to: 'your_controller#index', via: [:get, :post]
  get '/download/:path', to: 'your_controller#download'
end
```

**This way if you can use a namespace if you want to use under**

```ruby
namespace :admin do
  scope '/fcfinder' do
    match '/', to: 'your_controller#index', via: [:get, :post]
	get '/download/:path', to: 'your_controller#download'
  end
end 
```

###View Setting

####1.Method
**app/assets/javascripts/application.js in your file**

```js
//= require jquery
//= require jquery_ujs
```

these lines must be attached ***(make sure jQuery is loaded!!)***


**config/initializers/assets.rb** in the file to the bottom

```ruby
Rails.application.config.assets.precompile += %w( fcfinder.js )
Rails.application.config.assets.precompile += %w( fcfinder.css )
```

you must add the lines

**View the content of your file should be like this**

```html
<!DOCTYPE html>
<html>
  <head>
    <title>FcFinder</title>
    
   <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
   <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
   
   <%= javascript_include_tag 'fcfinder', 'data-turbolinks-track' => true %>
   <%= stylesheet_link_tag    'fcfinder', media: 'all', 'data-turbolinks-track' => true %>
   <%= csrf_meta_tags %>
  </head>
  <body>
    <div id="fcfinder"></div>
    
	<script type="text/javascript">
      $(function(){
        $("#fcfinder").fcFinder({
			// this value must be the address that you set in the route
			url:"/fcfinder",
        getFileCallback: function(url) {
          /**
			Integrated Editor For The First Stage Of The Process, You Can Leave This Value Blank
			By default CKEditor is working in an integrated manner with
		  */   
			}
        });
      });
    </script>
  </body>
</html>
```

####2.Method

**app/assets/javascripts/application.js in your file**
make sure that the jQuery files are installed

```js
//= require jquery
//= require jquery_ujs
```
under

```js
//= require fcfinder
```
add the line


**app/assets/stylesheets/application.css in file**

```css
 *= require fcfinder
```

add the line



**View the content of your file should be like this**

```html
<!DOCTYPE html>
<html>
  <head>
    <title>FcFinder</title>
    
   <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
   <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
   <%= csrf_meta_tags %>
   
  </head>
  <body>
    <div id="fcfinder"></div>
    
	<script type="text/javascript">
      $(function(){
        $("#fcfinder").fcFinder({
			// this value must be the address that you set in the route
			url:"/fcfinder",
        getFileCallback: function(url) {
          /**
			Integrated Editor For The First Stage Of The Process, You Can Leave This Value Blank
			By default CKEditor is working in an integrated manner with
		  */   
			}
        });
      });
    </script>
  </body>
</html>
```


**You Can Now Start Your Server And Test It :)**

## Integrated Operations
### CKEditor

Comes integrated with ckeditor by default. 
Ckeditor In A Page That Contains Flour

```js
CKEDITOR.replace( 'editor1',{
	/* In this way, you will specify the path to the Ckeditor in the Finder. */
	filebrowserBrowseUrl : 'http://localhost:3000/fcfinder'
});
```

### Tinymce

On the page that contains the TinyMCE editor

```js
function fcFinderBrowser (field_name, url, type, win) {
        tinymce.activeEditor.windowManager.open({
		/* URL Finder */
        file: "http://localhost:3000/admin/fcfinder",
		title: 'FCFinder File Manager',
        width: 900,
        height: 450,
        resizable: 'yes'
        }, {
            setUrl: function (url) {
				win.document.getElementById(field_name).value = url;
            }
        });
	return false;
}

tinymce.init({
		selector: "textarea#elm1",
		theme: "modern",
		file_browser_callback : fcFinderBrowser,
		....
		...
		..
		.
	});
```

**Resides on the page where fcfinder**

```js
$("#fcfinder").fcFinder({
        url:"/admin/fcfinder",
        getFileCallback: function(url) {
		
          if (typeof(window.opener) !== 'undefined' && window.opener !== null) {
            window.opener.FCFinder.callBack(url);
            window.close();
          }

          if (typeof(top.tinymce) !== 'undefined' && typeof(top.tinymce) !== null) {
            top.tinymce.activeEditor.windowManager.getParams().setUrl(url);
            top.tinymce.activeEditor.windowManager.close();
          }

      }
});
```

### Integrated process for the input

**the page where input is needed**

```html
<html>
<head>
	<script type="text/javascript">
	function openFCFinder(field) {
	window.FCFinder = {
        callBack: function(url) {
            field.value = url;
        }
    };
	
	window.open('http://localhost:3000/admin/fcfinder', 'kcfinder_textbox',
        'status=0, toolbar=0, location=0, menubar=0, directories=0, ' +
        'resizable=1, scrollbars=0, width=950, height=400'
    );
}
</script>
</head>
<body>
<input type="text" readonly="readonly" onclick="openFCFinder(this)"
    value="Click here and select a file double clicking on it" style="width:600px;cursor:pointer" />
</body>
</html>
```

**The page where is located the Finder (the Finder parameter setting)**


```js
$("#fcfinders").fcFinder({
        url:"/admin/fcfinder",
        getFileCallback: function(url) {

          if (typeof(window.opener) !== 'undefined' && window.opener !== null) {
            window.opener.FCFinder.callBack(url);
            window.close();
          }

          if (typeof(top.tinymce) !== 'undefined' && typeof(top.tinymce) !== null) {
            top.tinymce.activeEditor.windowManager.getParams().setUrl(url);
            top.tinymce.activeEditor.windowManager.close();
          }
	}
});
```

