# frozen_string_literal: true

class ShortLinksController < ApplicationController
  # POST /short_links
  def create
    if @short_link = ShortLink.find_by(short_link_params)
      render json: @short_link, status: :ok
    elsif (@short_link = ShortLink.new(short_link_params)) && @short_link.save
      render json: @short_link, status: :created
    else
      render json: { status: 422, errors: @short_link.errors }, status: :unprocessable_entity
    end
  end

  # GET /:short_link
  def redirect
    if @short_link = ShortLink.find_by(short_url: params[:short_link])
      @short_link.visits.create!(referrer: request.referer, user_agent: request.user_agent)
      respond_to do |format|
        format.html do
          redirect_to @short_link.long_url
        end
        format.json do
          render json: { status: 301, location: @short_link.long_url }, status: :moved_permanently
        end
      end
    else
      render json: { status: 404, error: "unknown short link" }, status: :not_found
    end
  end

  # GET /:short_link+
  def analytics
    short_url = params[:short_link].match(/^(.+)\+$/)[1] # route constraint guarantees match
    if @short_link = ShortLink.find_by(short_url: short_url)
      render json: { response: @short_link.visits }, status: :ok
    else
      render json: { status: 404, error: "unknown short link" }, status: :not_found
    end
  end

  private

    def short_link_params
      params.permit(:long_url, :user_id)
    end
end
