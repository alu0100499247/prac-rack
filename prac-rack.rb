# encoding: utf-8
require 'twitter'
require 'rack'
require 'thin'
require './configure.rb'


app = lambda do |env|
  	req = Rack::Request.new env
  	res = Rack::Response.new
  
  	if req.path_info == '/mitweet'
    
    	nombre = req['name']
	
    	usuario = Twitter.user(nombre)
    
    	res.write <<-"EOS"
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
      	<body>
		<img src="http://amesb.es/blog/wp-content/uploads/Qu%C3%A9-hacer-para-que-te-sigan-en-twitter1.png" align="right" width="200" height="200" />
	  	<form> 
	  		<p><h1>Introduce tu username: @<input type="text" name="name"></h1><br></p>
	  		
	  	</form>	
	  	<p><h3>Username</h3>      	: #{nombre} </p>
      		<p><h3>Nombre</h3>          : #{usuario.name} </p>
      		<p><h3>Seguidores</h3>     		: #{usuario.followers_count} </p>
      		<p><h3>Siguiendo a</h3>               : #{usuario.friends_count} </p>
      		<p><h3>Localizacion</h3>         : #{usuario.location} </p>
      		<p><h3>URL</h3>                  : #{usuario.url} </p>
    	EOS

    	tweet = Twitter.user_timeline(nombre).first

    	if tweet
		res.write <<-"EOS"
			<p><h3>Ultimo tweet</h3>           	  : #{tweet.text } </p>
			<p><h3>Hora del tweet</h3>         	  : #{tweet.created_at} </p>
			<p><h3>ID Tweet</h3>               	  : #{tweet.id} </p>
    	</body>
		EOS
    	end
  	else
    	res.write <<-"EOS"
    	<h1> Esta aplicación mostrará el último tweet de tu cuenta. Pulsa sobre la imagen para acceder a la aplicación :)</h1>
		<a href= 'localhost:8000/mitweet'><img src="http://eledelengua.com/imagenes/twitter-logo.png" align="right" width="200" height="200" /></a>  
    	EOS
  	end
  	res.finish
end


Rack::Handler::Thin.run app, :Port => 8000




