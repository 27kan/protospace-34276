class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]
  before_action :move_index, only: :edit

  def index
    @prototypes = Prototype.all
  end

  def new # 空のインスタンスを作って
    @prototype = Prototype.new
  end

  def create # 保存に失敗した時の値を保持するためインスタンス変数に代入する
    # 今回のつまづき1 createメソッドにこだわって条件分岐ができなかった
    # .findで取得しようとしてもDBに保存されていない情報だからidがなくてエラーになる
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def edit
    # before_action で投稿者とアクセスユーザーが同じかを確認
    @prototype = Prototype.find(params[:id])
  end

  def update # 更新の結果で条件分岐
    @prototype = Prototype.find(params[:id])
    # 情報更新のために送られてきた情報を格納 renderで返すからインスタンス変数
    if @prototype.update(prototype_params)
      # update(ストロングパラメーター)で保存の可否を判断できる
      redirect_to prototype_path(@prototype.id)
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params 
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_index # 投稿者以外が編集ページにアクセスできないようにする
    prototype_user = Prototype.find(params[:id]) 
    unless prototype_user.user_id == current_user.id
      redirect_to action: :index
    end
  end

end
