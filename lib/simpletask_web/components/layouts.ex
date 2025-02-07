defmodule SimpletaskWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use SimpletaskWeb, :controller` and
  `use SimpletaskWeb, :live_view`.
  """
  use SimpletaskWeb, :html
  use SaladUI

  def versions(), do: ["0.0.1"]

  def nav_main() do
    [
      %{
        title: "Cadastros",
        url: "#",
        items: [
          %{
            title: "Minha Unidade",
            url: "#"
          },
          %{
            title: "Tipos de Unidade",
            url: "#"
          }
        ]
      },
      %{
        title: "Building Your Application",
        url: "#",
        items: [
          %{
            title: "Routing",
            url: "#"
          },
          %{
            title: "Data Fetching",
            url: "#",
            is_active: true
          },
          %{
            title: "Rendering",
            url: "#"
          },
          %{
            title: "Caching",
            url: "#"
          },
          %{
            title: "Styling",
            url: "#"
          },
          %{
            title: "Optimizing",
            url: "#"
          },
          %{
            title: "Configuring",
            url: "#"
          },
          %{
            title: "Testing",
            url: "#"
          },
          %{
            title: "Authentication",
            url: "#"
          },
          %{
            title: "Deploying",
            url: "#"
          },
          %{
            title: "Upgrading",
            url: "#"
          },
          %{
            title: "Examples",
            url: "#"
          }
        ]
      },
      %{
        title: "API Reference",
        url: "#",
        items: [
          %{
            title: "Components",
            url: "#"
          },
          %{
            title: "File Conventions",
            url: "#"
          },
          %{
            title: "Functions",
            url: "#"
          },
          %{
            title: "next.config.js Options",
            url: "#"
          },
          %{
            title: "CLI",
            url: "#"
          },
          %{
            title: "Edge Runtime",
            url: "#"
          }
        ]
      },
      %{
        title: "Architecture",
        url: "#",
        items: [
          %{
            title: "Accessibility",
            url: "#"
          },
          %{
            title: "Fast Refresh",
            url: "#"
          },
          %{
            title: "Next.js Compiler",
            url: "#"
          },
          %{
            title: "Supported Browsers",
            url: "#"
          },
          %{
            title: "Turbopack",
            url: "#"
          }
        ]
      }
    ]
  end

  def search_form(assigns) do
    ~H"""
    <form>
      <.sidebar_group class="py-0">
        <.sidebar_group_content class="relative">
          <.label for="search" class="sr-only">
            Search
          </.label>
          <.sidebar_input id="search" placeholder="Search the docs..." class="pl-8"></.sidebar_input>
          <search class="pointer-events-none absolute left-2 top-1/2 size-4 -translate-y-1/2 select-none opacity-50">
          </search>
        </.sidebar_group_content>
      </.sidebar_group>
    </form>
    """
  end

  def version_switcher(assigns) do
    ~H"""
    <.sidebar_menu>
      <.sidebar_menu_item>
        <.dropdown_menu class="block">
          <.dropdown_menu_trigger>
            <.sidebar_menu_button
              size="lg"
              class="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
            >
              <div class="flex aspect-square size-8 items-center justify-center rounded-lg bg-sidebar-primary text-sidebar-primary-foreground">
                <.icon name="hero-exclamation-circle-mini" class="size-4" />
              </div>
              <div class="flex flex-col gap-0.5 leading-none">
                <span class="font-semibold">
                  Documentation
                </span>
                <span class="">
                  v<%= hd(versions()) %>
                </span>
              </div>
              <.icon name="hero-exclamation-circle-mini" class="ml-auto" />
            </.sidebar_menu_button>
          </.dropdown_menu_trigger>
          <.dropdown_menu_content class="w-full" align="start">
            <.menu>
              <.menu_item :for={item <- versions()}>
                v<%= item %>
              </.menu_item>
            </.menu>
          </.dropdown_menu_content>
        </.dropdown_menu>
      </.sidebar_menu_item>
    </.sidebar_menu>
    """
  end

  embed_templates "layouts/*"
end
