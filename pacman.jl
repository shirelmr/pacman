using Agents

const matrix = [
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 1 0 1 0 0 0 1 1 1 0 1 0 1 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 0 1 0 1 0 0 0 0 0 1 1 1 0 1 0;
    0 1 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 1 1 0 0 1 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 1 0 1 0 1 1 1 0 0 0 1 0 1 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
]

@agent struct Ghost(GridAgent{2})
    type::String = "Ghost"
end

function is_valid_position(pos, model)
    col, row = pos
    filas, columnas = size(matrix)

    if row < 1 || row > filas || col < 1 || col > columnas
        return false
    end

    return matrix[row, col] == 1
end

function walk!(agent, model)
    possible_moves = [(0,-1), (0,1), (-1,0), (1,0)]
    
    current_pos = agent.pos
    valid_positions = []
    
    for direction in possible_moves
        new_pos = (
            current_pos[1] + direction[1],
            current_pos[2] + direction[2]
        )
        if is_valid_position(new_pos, model)
            push!(valid_positions, new_pos)
        end
    end
    
    println(possible_moves)
    if !isempty(valid_positions)
        new_pos = rand(valid_positions)
        move_agent!(agent, new_pos, model)
    end
    println(agent.pos)
end

function agent_step!(agent, model)
    walk!(agent, model)
end

function initialize_model()
    filas, columnas = size(matrix)
    space = GridSpace((filas, columnas); periodic = false, metric = :manhattan)
    model = StandardABM(Ghost, space; agent_step!)
    return model
end

model = initialize_model()
a = add_agent!(Ghost, pos=(2, 2), model)
