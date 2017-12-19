class ApplicationController < ActionController::API
  private
  def my_user
    decoded = JWT.decode(request.headers['Authorization'], ENV["MY_SECRET"], ENV["EGGS"])
    decoded_id = decoded[0]['user_id']
    currentUser = User.find_by(id: decoded_id)
  end
end
