{ config, ... }:
{
  services = {
    litellm = {
      enable = true;
      port = 8085;
      openFirewall = true;
      settings = {
        model_list = [
          {
            model_name = "gemini-2.5-flash-lite";
            litellm_params = {
              model = "gemini/gemini-2.5-flash-lite";
              api_key = "$(cat ${config.sops.secrets."api/gemini/token".path})";
            };
          }
          {
            model_name = "gemini-2.5-flash";
            litellm_params = {
              model = "gemini/gemini-2.5-flash";
              api_key = "$(cat ${config.sops.secrets."api/gemini/token".path})";
            };
          }
          {
            model_name = "gemini-3-flash";
            litellm_params = {
              model = "gemini/gemini-3-flash";
              api_key = "$(cat ${config.sops.secrets."api/gemini/token".path})";
            };
          }
          {
            model_name = "gemma-3-12b";
            litellm_params = {
              model = "gemini/gemma-3-12b";
              api_key = "$(cat ${config.sops.secrets."api/gemini/token".path})";
            };
          }

          # Groq
          {
            model_name = "qwen3-32b";
            litellm_params = {
              model = "groq/qwen/qwen3-32b";
              api_key = "$(cat ${config.sops.secrets."api/groq/token".path})";
            };
          }
          {
            model_name = "llama-4-scout";
            litellm_params = {
              model = "groq/meta-llama/llama-4-scout-17b-16e-instruct";
              api_key = "$(cat ${config.sops.secrets."api/groq/token".path})";
            };
          }
        ];
      };
    };
  };
}
