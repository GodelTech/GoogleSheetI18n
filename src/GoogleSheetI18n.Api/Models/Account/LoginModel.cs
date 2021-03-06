using System.ComponentModel.DataAnnotations;

namespace GoogleSheetI18n.Api.Models.Account
{
    public class LoginModel
    {
        [Required]
        public string Username { get; set; }

        [Required]
        public string Password { get; set; }
    }
}
