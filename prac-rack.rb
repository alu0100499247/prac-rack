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
      	<body>
	  	<form> 
	  		<p>Introduce tu username: @<input type="text" name="name"><br></p>
	  		
	  	</form>
	  	<p>Nombre de usuario      	: #{nombre} </p>
      		<p>Nombre real          : #{usuario.name} </p>
      		<p>Seguidores     		: #{usuario.followers_count} </p>
      		<p>Amigos               : #{usuario.friends_count} </p>
      		<p>Localizacion         : #{usuario.location} </p>
      		<p>URL                  : #{usuario.url} </p>
    	EOS

    	tweet = Twitter.user_timeline(nombre).first

    	if tweet
		res.write <<-"EOS"
			<p>Ultimo tweet           	  : #{tweet.text } </p>
			<p>Hora del tweet         	  : #{tweet.created_at} </p>
			<p>ID Tweet               	  : #{tweet.id} </p>
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
#<a href="localhost:9999/twittero?name=cristhianj90"> Aqui </a>
#<p> Pagina no accesible, visite <a href= 'localhost:9999/twittero'><input type="submit" value="Submit"></a></p>










