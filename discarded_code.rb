discarded_code.rb

<!--  #put into a form, with value on edit forms use post, play with text to name link/button -->
<input name='_method' type='submit' value='Submit' />
          <a data-method="put" href="/like">Like!</a>



           #put in rest_id as set value, then after you can see it's working, make it hidden.



john thoughts on tags

store them as a string " a | b | c | d "

then you can split on the pipes
look at carmen sandiego answer file from slack, you can search to match the first part of the tag %hang% from hangover helper and display the restaurants that match in tag list

john terminal notes


From: /Users/Allison/Dropbox (Personal)/General Assembly/Project2/project2/server.rb @ line 90 self.GET /review/:id:

    85:     get "/review/:id" do
    86:       @id = params[:id].to_i
    87:       @restaurant = conn.exec("SELECT * FROM restaurants WHERE id = #{@id}")
    88:       @comments = conn.exec("SELECT * FROM comments WHERE restaurant_id = #{@id}")
    89:
 => 90:       binding.pry
    91:       erb :restaurant
    92:     end
    93:
    94:     post "/review" do
    95:       @restaurant_name = params[:restaurant_name]

[1] Pry(#<Sinatra::Server>)> @re
readline                  render                    respond_to?
readlines                 render_ruby               respond_to_missing?
redirect                  request                   response
redirect?                 request=                  response=
redo                      require                   retry
reload-code               require_relative          return
reload-method             rescue
remove_instance_variable  reset
[1] Pry(#<Sinatra::Server>)> @restaurant
=> #<PG::Result:0x007fd804386650 status=PGRES_TUPLES_OK ntuples=1 nfields=7 cmd_tuples=1>
[2] Pry(#<Sinatra::Server>)> @restaurant.to_a
=> [{"id"=>"3",
  "restaurant_name"=>"Bounce",
  "menu_item"=>"Spicy steak wrap",
  "review"=>"a little small but more filling than expected. Good flavors",
  "likes"=>"0",
  "user_id"=>"1",
  "tag_id"=>"1"}]
[3] Pry(#<Sinatra::Server>)> @restaurant.to_a[0]
=> {"id"=>"3",
 "restaurant_name"=>"Bounce",
 "menu_item"=>"Spicy steak wrap",
 "review"=>"a little small but more filling than expected. Good flavors",
 "likes"=>"0",
 "user_id"=>"1",
 "tag_id"=>"1"}
[4] Pry(#<Sinatra::Server>)> @restaurant.to_a[0]['id']
=> "3"



<ul class='restos'>
        <li><%= place ["review"] %></li>
        <li><%= @fname %></li>
        <li>tag placeholder</li>
        <li>
          <form class='like' action='/like' method='post'>
            <input name='restaurant_id' value='<%= @restaurant_id %>' type='hidden' />
            <input name='likes' type='hidden' />
            <input type='submit' value='Like!' />
          </form>
        </li>
      </ul>


              <ul class ='restos'>
          <li><%= place["restaurant_name"] %>,
          <%= place["menu_item"] %>,
          <%= place["likes"] %>
          </li>
        </ul>


<div class='tags'>
      <%= @tags.each do |tag| %>
        <ul>
          <li><%= tag["tag"] %></li>
        </ul>
      <% end %>
    </div>
