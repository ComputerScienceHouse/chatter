defmodule Chatter.DirectPoint do
  @type t :: %__MODULE__{
          :owner => String.t(),
          :notes => String.t(),
          :id => integer(),
          :state => :speaking | :spoken | :waiting,
          :direct_points => [__MODULE__.t()]
        }
  defstruct [:owner, :notes, :id, :state, :direct_points]
end
