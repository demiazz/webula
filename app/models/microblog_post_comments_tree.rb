class MicroblogPostCommentsTree
  include Mongoid::Document

  field :author_ids, :type => Array, :default => []
  field :comments, :type => Hash, :default => {}

  belongs_to :post, :class_name => "MicroblogPost", :inverse_of => :comments

  def add_comment!(author, text, parent=nil)
    # Если parent не передан, то комментарий предазначен для самого поста
    if parent.nil?
      comment = Hash.new
      self.author_ids << author.id unless self.author_ids.include?(author.id)
      comment[:author_id] = author.id
      comment[:text] = text
      comment[:created_at] = Time.now.utc
      comment[:parent] = nil
      comment[:replies] = {}
      self.comments["id#{BSON::ObjectId.new}"] = comment
    else
      comment = Hash.new
      self.author_ids << author.id unless self.author_ids.include?(author.id)
      comment[:author_id] = author.id
      comment[:text] = text
      comment[:created_at] = Time.now.utc
      comment[:parent] = parent
      comment[:replies] = {}
      self.find_comment(parent)[:replies]["id#{BSON::ObjectId.new}"] = comment
    end
    self.save
  end

  def find_comment(id)
    
    def _find_comment(id, comments)
      if comments.size == 0
        return nil
      end
      if comments.include?(id)
        return comments[id]
      else
        comments.each do |comment|
          result = _find_comment(id, comment[:replies])
          return result unless result.nil?
        end
        return nil
      end
    end

    return _find_comment(id, self.comments)
  end

  def strip_comment(comment)
    parent_comment = Hash.new
    parent_comment[:author_id] = comment[:author_id]
    parent_comment[:text] = comment[:text]
    parent_comment[:created_at] = comment[:created_at]
    parent_comment[:parent] = comment[:parent]
    return parent_comment
  end

  def comment_to_array(comment)
    result = []
    result << strip_comment(comment)
    if comment[:replies].size > 0
      comment[:replies].each do |reply|
        result += comment_to_array(reply[1])
      end
    end
    return result
  end

  def to_a
    if self.comments.size > 0
      result = []
      self.comments.each do |comment|
        result += comment_to_array(comment[1])
      end
      # получаем авторов
      authors = {}
      User.where(:_id.in => self.author_ids).each do |author|
        authors[author.id] = author
      end
      # привязываем авторов
      result.each do |comment|
        comment[:author] = authors[comment[:author_id]]
      end
      return result
    else
      return []
    end
  end

end
