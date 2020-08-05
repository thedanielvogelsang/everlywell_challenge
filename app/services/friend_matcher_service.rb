class FriendMatcherService
  class FriendError < StandardError
    attr_reader :users
    def initialize(msg = "Users are already friends", user1, user2)
      @users = [user1, user2]
      super(msg)
    end
  end

  attr_reader :users, :path

  def initialize(new_friend:, search_user:)
    if search_user.is_friend?(new_friend) || new_friend.is_friend?(search_user)
      raise FriendError.new(new_friend, search_user)
    else
       @users = [search_user.id, new_friend.id]
    end
  end

  def find_friend_path
    create_adjacency_matrix
    if issue_breadth_search(adj_matrix, new_friend_node, original_user_node)
      @path = id_path
      return path
    else
      puts 'There is no path between users!'
      false
    end
  end

  private
  attr_reader :adj_matrix, :id_path, :new_friend_node, :original_user_node, :user_count, :user_ids

  def create_adjacency_matrix
    @user_ids = User.pluck(:id)
    @new_friend_node = user_ids.index(users[1])
    @original_user_node = user_ids.index(users[0])
    @user_count = user_ids.count
    @adj_matrix = user_ids.map do |id|
      user_ids.map do |uid|
        user = User.find(id)
        user.is_friend?(uid) ? 1 : 0
      end
    end
  end

  def issue_breadth_search(matrix, n1, n2)
    node_array = [n1]
    @id_path = []
    # puts "The initial node_array is #{node_array}"

    loop do
      curr_node = node_array.pop

      return false if curr_node.nil?

      id_path << user_ids[curr_node]
      # puts "The next node to be checked is #{curr_node}."
      if curr_node.nil?
        return false
      elsif curr_node == n2
        # puts "Terminal node #{curr_node} found!"
        # puts "The path between node #{n1} and node #{n2} is: #{id_path}"
        return true
      end

      # puts "Iterating through the following array: #{matrix[curr_node]}"
      children = (0..matrix.length - 1).to_a.select do |i|
        # puts "Checking the #{i} index which value #{matrix[curr_node][i]}"
        matrix[curr_node][i] == 1 && i != n1
      end

      # puts "The children array returned: #{children}"
      node_array = children + node_array
      # puts "After appending children to node_array, node_array is #{node_array}"
    end
  end
end