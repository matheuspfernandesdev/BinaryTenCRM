using BinaryTenCRM.Models;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace BinaryTenCRM.Controllers;

public class AccessController : Controller
{
    public IActionResult Login()
    {
        ClaimsPrincipal principal = HttpContext.User;

        if (principal.Identity.IsAuthenticated)
        {
            return RedirectToAction("Index", "Home");
        }

        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Login(VMLogin login)
    {
        if (login.Email == "matheuswith51@hotmail.com" && login.Password == "123")
        {
            await ConfigureLogin(login);

            return RedirectToAction("Index", "Home");
        }

        ViewData["LoginValidation"] = "Usuário não encontrado";

        return View();
    }

    private async Task ConfigureLogin(VMLogin login)
    {
        List<Claim> claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Email, login.Email),
                new Claim("binaryTen", "10")
            };

        ClaimsIdentity identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);

        AuthenticationProperties props = new AuthenticationProperties()
        {
            AllowRefresh = true,
            IsPersistent = login.RememberMe
        };

        await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme,
                                     new ClaimsPrincipal(identity), props);
    }
}
