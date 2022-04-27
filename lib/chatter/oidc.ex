defmodule Chatter.OIDC.UserInfo do
  @type t :: %__MODULE__{
          :given_name => String.t(),
          :family_name => String.t(),
          :preferred_username => String.t(),
          :is_admin? => boolean
        }
  @derive Jason.Encoder
  defstruct [
    :given_name,
    :family_name,
    :preferred_username,
    :is_admin?
  ]
end
