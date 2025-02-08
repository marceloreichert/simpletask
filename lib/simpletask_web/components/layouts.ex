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

  import Lucideicons, except: [import: 1, quote: 1, menu: 1, link: 1]

  def versions(), do: ["0.0.1"]

  def teams() do
    [
      %{
        name: "Clinica Amendoim Quasqualho",
        logo: &gallery_vertical_end/1,
        plan: "Clinica Medica"
      }
    ]
  end

  def nav_menu(user) do
    [
      %{
        title: "Cadastros",
        url: "#",
        icon: &square_terminal/1,
        is_active: true,
        items: [
          %{
            title: "Tipo de Unidade",
            url: ~p"/unit_types"
          },
          %{
            title: "Unidade",
            url: ~p"/units/#{user.unit_id}"
          },
          %{
            title: "Salas",
            url: ~p"/rooms"
          },
        ]
      }
    ]
  end

  def projects() do
    [
      %{
        name: "Design Engineering",
        url: "#",
        icon: "hero-building-office-2"
      },
      %{
        name: "Sales & Marketing",
        url: "#",
        icon: "hero-building-office-2"
      },
      %{
        name: "Travel",
        url: "#",
        icon: "hero-building-office-2"
      }
    ]
  end

  def sidebar_main(assigns) do
    ~H"""
    <.sidebar collapsible="icon" id="main-sidebar">
      <.sidebar_header>
        <.team_switcher teams={teams()} />
      </.sidebar_header>
      <.sidebar_content>
        <.nav_main items={nav_menu(@user)} />
      </.sidebar_content>
      <.sidebar_footer>
        <.nav_user user={@user} />
      </.sidebar_footer>
      <.sidebar_rail />
    </.sidebar>
    """
  end

  def nav_main(assigns) do
    ~H"""
    <.sidebar_group>
      <.sidebar_group_label>
        Plataforma
      </.sidebar_group_label>
      <.sidebar_menu>
        <.collapsible
          :for={item <- @items}
          id={id(item.title)}
          aschild="aschild"
          open={item[:is_active]}
          class="group/collapsible block"
        >
          <.sidebar_menu_item>
            <.as_child tag={&collapsible_trigger/1} child={&sidebar_menu_button/1} tooltip={item.title}>
              <.dynamic :if={not is_nil(item.icon)} tag={item.icon} />
              <span>
                <%= item.title %>
              </span>
              <.chevron_right class="ml-auto transition-transform duration-200 group-data-[state=open]/collapsible:rotate-90" />
            </.as_child>

            <.collapsible_content>
              <.sidebar_menu_sub>
                <.sidebar_menu_sub_item :for={sub_item <- item.items}>
                  <.as_child tag={&sidebar_menu_sub_button/1} child="a" href={sub_item.url}>
                    <span>
                      <%= sub_item.title %>
                    </span>
                  </.as_child>
                </.sidebar_menu_sub_item>
              </.sidebar_menu_sub>
            </.collapsible_content>
          </.sidebar_menu_item>

        </.collapsible>
      </.sidebar_menu>
    </.sidebar_group>
    """
  end


  def nav_user(assigns) do
    ~H"""
    <.sidebar_menu>
      <.sidebar_menu_item>
        <.dropdown_menu class="block">
          <.as_child tag={&dropdown_menu_trigger/1}
            child={&sidebar_menu_button/1}
            size="lg"
            class="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
          >
            <.avatar class="h-8 w-8 rounded-lg">
              <.avatar_image src={@user.avatar} alt={@user.name} />
              <.avatar_fallback class="rounded-lg">
                CN
              </.avatar_fallback>
            </.avatar>
            <div class="grid flex-1 text-left text-sm leading-tight">
              <span class="truncate font-semibold">
                <%= @user.name %>
              </span>
              <span class="truncate text-xs">
                <%= @user.email %>
              </span>
            </div>
            <.chevrons_up_down class="ml-auto size-4" />
          </.as_child>
          <.dropdown_menu_content
            class="w-[--radix-dropdown-menu-trigger-width] min-w-56 rounded-lg"
            side="right"
            align="end"
            sideoffset="{4}"
          >
            <.menu>
              <.menu_label class="p-0 font-normal">
                <div class="flex items-center gap-2 px-1 py-1.5 text-left text-sm">
                  <.avatar class="h-8 w-8 rounded-lg">
                    <.avatar_image src="{user.avatar}" alt="{user.name}"></.avatar_image>
                    <.avatar_fallback class="rounded-lg">
                      CN
                    </.avatar_fallback>
                  </.avatar>
                  <div class="grid flex-1 text-left text-sm leading-tight">
                    <span class="truncate font-semibold">
                      <%= @user.name %>
                    </span>
                    <span class="truncate text-xs">
                      <%= @user.email %>
                    </span>
                  </div>
                </div>
              </.menu_label>
              <.menu_separator></.menu_separator>
              <dropdownmenugroup>
                <.menu_item>
                <.link href={~p"/users/settings"} class="hover:text-zinc-700">
                  <.icon name="hero-x-mark-solid" class="w-4 h-4 mr-2" /> Dados do Usuário
                  </.link>
                </.menu_item>
              </dropdownmenugroup>
              <.menu_separator></.menu_separator>
              <.menu_item>
              <.link href={~p"/users/log_out"} method="delete" class="hover:text-zinc-700">
                <.icon name="hero-x-mark-solid" class="w-4 h-4 mr-2" /> Log out
                </.link>
              </.menu_item>
            </.menu>
          </.dropdown_menu_content>
        </.dropdown_menu>
      </.sidebar_menu_item>
    </.sidebar_menu>
    """
  end

  def team_switcher(assigns) do
    assigns = assign(assigns, :active_team, hd(assigns.teams))

    ~H"""
    <.sidebar_menu>
      <.sidebar_menu_item>
        <.dropdown_menu class="block">
          <.as_child tag={&dropdown_menu_trigger/1}
            child={&sidebar_menu_button/1}
            size="lg"
            class="data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
          >
            <div class="flex aspect-square size-8 items-center justify-center rounded-lg bg-sidebar-primary text-sidebar-primary-foreground">
              <.dynamic tag={@active_team.logo} class="size-4" />
            </div>
            <div class="grid flex-1 text-left text-sm leading-tight">
              <span class="truncate font-semibold">
                <%= @active_team.name %>
              </span>
              <span class="truncate text-xs">
                <%= @active_team.plan %>
              </span>
            </div>
            <.chevron_right class="ml-auto" />
          </.as_child>
          <.dropdown_menu_content
            class="w-[--radix-dropdown-menu-trigger-width] min-w-56 rounded-lg"
            align="start"
            side="right"
          >
            <.menu>
              <.menu_label class="text-xs text-muted-foreground">
                Teams
              </.menu_label>

              <.menu_item :for={{team, index} <- Enum.with_index(@teams)} class="gap-2 p-2">
                <div class="flex size-6 items-center justify-center rounded-sm border">
                  <.dynamic tag={team.logo} class="size-4 shrink-0" />
                </div>
                <%= team.name %>
                <.dropdown_menu_shortcut>
                  ⌘<%= index + 1 %>
                </.dropdown_menu_shortcut>
              </.menu_item>
            </.menu>
          </.dropdown_menu_content>
        </.dropdown_menu>
      </.sidebar_menu_item>
    </.sidebar_menu>
    """
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
