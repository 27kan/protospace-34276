class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # find(params[:id])にプロトタイプもユーザー情報も入ってる
  end
end
