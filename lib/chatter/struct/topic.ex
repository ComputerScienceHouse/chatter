defmodule Chatter.Topic do
  @type t :: %__MODULE__{
          :owner => String.t(),
          :name => String.t(),
          :notes => String.t(),
          :direct_points => [Chatter.DirectPoint.t()]
        }
  defstruct [:owner, :name, :notes, :direct_points]
end
