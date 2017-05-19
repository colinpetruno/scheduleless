module NotDeletable
  extend ActiveSupport::Concern

  def delete
    raise NotDeletableError.new()
  end

  def destroy
    raise NotDeletableError.new()
  end

  def destroy!
    raise NotDeletableError.new()
  end

  class NotDeletableError < StandardError; end
end
