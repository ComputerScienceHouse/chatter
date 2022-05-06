defmodule Chatter.DirectPoint do
  @type t :: %__MODULE__{
          :owner => String.t(),
          :notes => String.t(),
          :id => integer(),
          :direct_points => [__MODULE__.t()]
        }
  defstruct [:owner, :notes, :id, :direct_points]
end
