defmodule Chatter.Space do
  @type t :: %__MODULE__{
          :owner => String.t(),
          :topics => [Chatter.Topic, ...],
          :current_speaker => String.t(),
          :connection_cap => integer()
        }
  defstruct [:owner, :topics, :current_speaker, :connection_cap]
end
