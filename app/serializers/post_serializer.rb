# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :published, :content, :autor

  def autor
    user = object.user
    {
      name: user.name,
      email: user.email,
      id: user.id
    }
  end
end
