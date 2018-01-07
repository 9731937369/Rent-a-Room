<ul>
  <div class = "row">
    <div class = "col-md-12">
    <h3><p><%= @room.name %></h3>

    <%if user_signed_in? %>
          <%if (can? :update, @room) %>
            <b style="float:right;"><%= link_to "Edit", edit_room_path(@room) %></b> 
          <%end %> 
          <% if can? :destroy, @room %>
            <b style="float:right;"><%= link_to "Delete", @room, method: :delete, data: { confirm: 'Are you sure?'}%></b> 
          <% end %></br>    
      <% end %>
    <b>Owner : </b><%= @room.user.username.capitalize%> <b style = "float:right">Price :<%= @room.price %></b><br/><br/>
    <b>Contact : </b><%= @room.user.mobile %><br/></br>
    </div>
  </div>
  <div class = "row">
    <div class="col-md-12">
      <%= image_tag(@room.images, :size => "1120x300")%>
    </div>
    <div class = "col-md-12">  
      <br/><b >Description : </b><br><%= @room.description %><br/><br/>
      <b>Rules : </b><br><%= @room.rules%> <br/><br/>
    </div>
   
    <div class = "col-md-6">       
      <b>Address : </b> <%= @room.address%></br></br>
      <b>City : </b><%= @room.city.name %><br/><br/>
      <b>Latitude : </b><%= @room.latitude %><br/><br/>
      <b>Longitude : </b><%= @room.longitude %><br><br>
    </div>         
    <div class = "col-md-6">
      <b>Amenities : </b>
      <ol>
        <% @room.amenities.each do |amenity| %>
          <li><b><%= amenity.name %> : </b>   <%= amenity.description%></li><br>
        <% end %>
      
      </ol>
    </div>
  </div>
  <div class = "row">
  <div class = "col-md-4">
      <% if user_signed_in? %>
      <%# if current_user.id == @room.user.id %>
       <h4>Special prices</h4>
        <% if @room.special_prices.empty? %>
            <p>No Specal prices for this room</p>
        <% else %>
            <table class = "table">
                <tr>
                    <th>Start-Date</th>
                    <th>End-Date</th>
                    <th>New Price</th>
                    <th>Old price</th>
                </tr>
                <% @room.special_prices.each do |f| %>
                    <tr>
                        <td><%= f.start_date %></td>
                        <td><%= f.end_date%></td>
                        <td><%= f.price %></td>
                        <td><%= @room.price%></td>
                    </tr>
                <% end %>
            </table>
        <% end %>
      <% end %>
  </div>
  <div class = "col-md-4">
    <!-- Form for special price -->
    <% if user_signed_in?  %>
      
      <% if current_user.id == @room.user.id %>

        <h4> Add Special Prices</h4>
            <%= form_for @special_price do |f| %>
                <%= f.hidden_field :room_id, value: @room.id %>
                <p class = "form-group">
                  <strong>Start Date :</strong><%= f.date_select :start_date ,class: "form-control"%>
                  <span id = "startError"></span>
                </p>
                <p class = "form-group">
                  <strong>End Date :</strong><%= f.date_select :end_date,class: "form-control" %>
                  <span id = "endError"></span>
                </p>
                <p class = "form-group">
                  <strong>Price :</strong> <%= f.number_field :price,class: "form-control" %>
                  <span id = "priceError"></span>
                </p>
                <%= f.submit "ADD SPECIAL PRICE", class: "btn btn-primary"%>
            <% end %>
        <% end %>
    <% end %>
  </div>
  <!-- form for booking -->
  <div class = "col-md-4">
    <% if user_signed_in? %>
      <h4>Book Room</h4>
        <%= form_for @booking do |f| %>
            
            <p class = "form-group">
              <strong>Start Date:</strong> <%= f.date_select :start_date, class: "form-control"%>
              <span id = "startdateError"></span>
            </p>

            <p class = "form-group">
              <strong>End Date :</strong> <%= f.date_select :end_date,class: "form-control" %>
              <span id = "enddateError"></span>
            </p>
             
              <%= f.hidden_field :room_id, value: @room.id %>
              
              <% if user_signed_in? && current_user.role.name == "admin" %>
                <%= f.collection_select :user_id, User.all, :id, :username %>
              <% end %>

              <%= f.submit "BOOK ROOM" , class: "btn btn-primary" %>
            
        <% end %>
      <% end %>
  </div>
  </div>
  <div class = "row">
  <div class = "col-md-8">
  <!-- **************Review display********************* -->
    <% room = 0 %>
    <% @room.reviews.each do |review| %>
      <%room = room + (((review.food_rating + review.cleanliness_rating + review.safety_rating + review.facility_rating + review.locality_rating)/5.0).to_f)/(@room.reviews.length) %>
    <% end %>
    
    <h4>Rating of Review : <%= room.round(1)%></h4>
    <%if @room.reviews.empty? %>
      <h4>No reviews</h4>
    <% else %>
        <% @room.reviews.each do |review| %>
           
              Review : <%= review.review %> </br>
              Food Rating : <%= review.food_rating%> </br>
              Cleanliness Rating : <%= review.cleanliness_rating%> </br>
              Safety Rating : <%= review.safety_rating %> </br>
              Facility Rating : <%= review.facility_rating %> </br>
              Locality Rating : <%= review.locality_rating %> </br>
              Average Rating : <%= ((review.food_rating + review.cleanliness_rating + review.safety_rating + review.facility_rating + review.locality_rating)/5.0) %> </br>
              <br/><br/>
              <% if user_signed_in? %>
                  <% if can? :update, review %>
                      <%#= link_to 'Edit', edit_review_path(review) %>
                  <% end %>
                  <% if can? :destroy, review %>
                      <%#= link_to 'Destroy', review, method: :delete, data: { confirm: 'Are you sure?'}%>
                  <% end %>
              <% end %>
        <% end %> 
    <% end %>
  </div>
  <!-- Review form -->
  <div class = "col-md-4">
  <% if user_signed_in?&&current_user.bookings.any? %>
      <%@room.bookings.each do |booking| %>
          <% if booking.user_id == current_user.id && booking.end_date <= Date.today %>
          <br>
          
              <h2>Add Your Review</h2>
                  <%= form_for(@review) do |f| %>
                      <div class="field" class="form-group">
                        <%= f.label :review %><br>
                        <%= f.text_area :review,class: "form-control" %>
                        <span id="reviewError"></span>
                      </div>
                      <div class="field" id = "food">
                      <h5> 5 – Excellent, 4 – Good, 3 – Average, 2 – Fair, 1- Poor</h5>
                        <%= f.label :food_rating %><br>
                        <%= f.radio_button :food_rating, 1 %> 1
                        <%= f.radio_button :food_rating, 2 %> 2
                        <%= f.radio_button :food_rating, 3 %> 3
                        <%= f.radio_button :food_rating, 4 %> 4
                        <%= f.radio_button :food_rating, 5 %> 5
                        <span id = "foodError"></span>
                      </div>
                      <div class="field" id = "clean">
                        <%= f.label :cleanliness_rating %><br>
                        <%= f.radio_button :cleanliness_rating, 1 %> 1
                        <%= f.radio_button :cleanliness_rating, 2 %> 2
                        <%= f.radio_button :cleanliness_rating, 3 %> 3
                        <%= f.radio_button :cleanliness_rating, 4 %> 4
                        <%= f.radio_button :cleanliness_rating, 5 %> 5
                        <span id = "cleanError"></span>
                      </div>
                      <div class="field" id = "safety">
                        <%= f.label :safety_rating %><br>
                        <%= f.radio_button :safety_rating, 1 %> 1
                        <%= f.radio_button :safety_rating, 2 %> 2
                        <%= f.radio_button :safety_rating, 3 %> 3
                        <%= f.radio_button :safety_rating, 4 %> 4
                        <%= f.radio_button :safety_rating, 5 %> 5
                        <span id = "safetyError"></span>
                      </div>
                      <div class="field" id = "facility">
                        <%= f.label :facility_rating %><br>
                        <%= f.radio_button :facility_rating, 1 %> 1
                        <%= f.radio_button :facility_rating, 2 %> 2
                        <%= f.radio_button :facility_rating, 3 %> 3
                        <%= f.radio_button :facility_rating, 4 %> 4
                        <%= f.radio_button :facility_rating, 5 %> 5
                        <span id = "facilityError"></span>
                      </div>
                      <div class="field" id= "locality">
                        <%= f.label :locality_rating %><br>
                        <%= f.radio_button :locality_rating, 1 %> 1 
                        <%= f.radio_button :locality_rating, 2 %> 2
                        <%= f.radio_button :locality_rating, 3 %> 3
                        <%= f.radio_button :locality_rating, 4 %> 4
                        <%= f.radio_button :locality_rating, 5 %> 5
                        <span id = "localityError"></span>
                      </div>

                        <%= f.hidden_field :room_id, value: @room.id %>
                        <%= f.hidden_field :user_id, value: current_user.id %>
                      <div class="actions">
                          <%= f.submit "submit", id: "value", class: "btn btn-primary" %>
                      </div>
                    <% end %>
              <% end %>
          <% end %>
  <% end %>
  </div>
  </div>
  <div class = "row">
    <center>
      <div class = "col-md-12">
        <div class="page-header">
            <h2>Location</h2>
        </div>
          <iframe width="700" height="500" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/place?key=AIzaSyBipgxMczyujD8knh17CWPulk7h2shwOF8&q=<%= @room.latitude %>,<%= @room.longitude %>"></iframe>
      </div>
    </center>
  </div>
</ul>
<script>

//<!-- Script for Review -->

errors = {
  review: false,
  food_rating: false,
  clean: false,
  safety: false,
  facility: false,
  locality: false
}

  var reviewHandle = document.getElementById('review_review');
  var foodHandle = document.getElementById('food');
  var cleanHandle = document.getElementById('clean');
  var safetyHandle = document.getElementById('safety');
  var facilityHandle = document.getElementById('facility');
  var localityHandle = document.getElementById('locality');

  var submitHandle = document.getElementById('value')

  var formHandle = document.getElementById('new_review') 

  var foodInput = foodHandle.getElementsByTagName('input')  
  var cleanInput = cleanHandle.getElementsByTagName('input');
  var facilityInput = facilityHandle.getElementsByTagName('input');
  var localityInput = localityHandle.getElementsByTagName('input');
  var safetyInput = safetyHandle.getElementsByTagName('input');
  
  var reviewMsgHandle = document.getElementById('reviewError');
  var cleanMsgHandle = document.getElementById('cleanError');
  var safetyMsgHandle = document.getElementById('safetyError');
  var facilityMsgHandle = document.getElementById('facilityError');
  var foodMsgHandle = document.getElementById('foodError');
  var localityMsgHandle = document.getElementById('localityError');

  reviewHandle.addEventListener('keyup',function(){
    if(reviewHandle.value.length < 150 ){
      console.log(reviewHandle.value.length);
      submitHandle.disabled = true;    
      }
 },false) 

function validatereview(){
      if(reviewHandle.value == ""){
        reviewMsgHandle.innerHTML = "Can't Be blank";
        errors.review = false;     
      }else if(reviewHandle.value.length < 150) {
        reviewMsgHandle.innerHTML = "Review should contain minimum 5 Characters";
        errors.review = false;
      }else{
        reviewMsgHandle.innerHTML = "";
        errors.review  = true;
      }
}

function validatefood(){   
  var selected = 0;
    for(var i = 0;i < foodInput.length;i++){
      if(foodInput[i].checked){
        selected = foodInput[i].value;
      }
    }
    if(selected == 0){
      foodMsgHandle.innerHTML = "cont be blank";
      errors.food_rating = false
    }else{
      foodMsgHandle.innerHTML = "";
      errors.food_rating = true;
    }

}

function validateclean(){   
  var selected = 0;
    for(var i = 0;i < cleanInput.length;i++){
      if(cleanInput[i].checked){
        selected = cleanInput[i].value;
      }
    }
    if(selected == 0){
      cleanMsgHandle.innerHTML = "cont be blank";
       errors.clean = false
    }else{
    cleanMsgHandle.innerHTML = "";
       errors.clean = true;
    }
}

function validatelocality(){   
  var selected = 0;
    for(var i = 0;i < localityInput.length;i++){
      if(localityInput[i].checked){
        selected = localityInput[i].value;
      }
    }
    if(selected == 0){
      localityMsgHandle.innerHTML = "cont be blank";
       errors.locality = false
    }else{
      localityMsgHandle.innerHTML = "";
       errors.locality = true;
    }
}


function validatefacility(){   
  var selected = 0;
    for(var i = 0;i < facilityInput.length;i++){
      if(facilityInput[i].checked){
        selected = facilityInput[i].value;
      }
    }
    if(selected == 0){
      facilityMsgHandle.innerHTML = "cont be blank";
       errors.facility = false
    }else{
    facilityMsgHandle.innerHTML = "";
       errors.facility = true;
    }
}


function validatesafety(){   
  var selected = 0;
    for(var i = 0;i < safetyInput.length;i++){
      if(safetyInput[i].checked){
        selected = safetyInput[i].value;
      }
    }
    if(selected == 0){
      safetyMsgHandle.innerHTML = "cont be blank";
       errors.safety = false
    }else{
      safetyMsgHandle.innerHTML = "";
       errors.safety = true;
    }
}

formHandle.addEventListener('submit',function(e){
  validatefood();
  validatereview();
  validatelocality();
  validatefacility();
  validatesafety();
  validateclean();

   if(Object.values(errors).includes(false)){
    e.preventDefault();
  }
},false)
</script>