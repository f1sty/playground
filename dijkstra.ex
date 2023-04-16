defmodule Dijkstra do
  @graph %{
    "book" => %{"rare_lp" => 5, "poster" => 0},
    "rare_lp" => %{"bass_guitar" => 15, "drum_set" => 20},
    "poster" => %{"bass_guitar" => 30, "drum_set" => 35},
    "bass_guitar" => %{"piano" => 20},
    "drum_set" => %{"piano" => 10},
    "piano" => %{}
  }

  def find_path(start_node, finish_node, graph \\ @graph) do
    find_path(graph, start_node, finish_node, [], %{})
  end

  defp find_path(_graph, finish_node, finish_node, _visited_nodes, steps) do
    unwind(steps, finish_node, [])
  end

  defp find_path(graph, current_node, finish_node, visited_nodes, steps) do
    neighbours = Map.get(graph, current_node)
    current_node_cost = get_in(steps, [current_node, :cost]) || 0

    steps =
      Enum.reduce(
        neighbours,
        steps,
        fn {node, weight}, acc ->
          Map.update(acc, node, %{parent: current_node, cost: weight + current_node_cost}, fn
            %{cost: c} when c > weight + current_node_cost ->
              %{parent: current_node, cost: weight + current_node_cost}

            with_smaller_cost ->
              with_smaller_cost
          end)
        end
      )

    next_node =
      steps
      |> Enum.reject(fn {node, _} -> node in visited_nodes end)
      |> Enum.min(fn {_, a}, {_, b} -> a.cost <= b.cost end)
      |> elem(0)

    visited_nodes = [next_node | visited_nodes]

    find_path(graph, next_node, finish_node, visited_nodes, steps)
  end

  defp unwind(steps, current_node, path) do
    {node, steps} = Map.pop(steps, current_node)

    case is_nil(node) do
      false ->
        next_node = node.parent
        unwind(steps, next_node, [current_node | path])

      true ->
        [current_node | path]
    end
  end
end
