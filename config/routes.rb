# frozen_string_literal: true

Rails.application.routes.draw do
  post "short_link", to: "short_links#create"
  get ":short_link", to: "short_links#redirect"
end
