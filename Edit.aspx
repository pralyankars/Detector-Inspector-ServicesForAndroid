<%@ Page Language="C#" MasterPageFile="~/Views/Shared/NewWindow.Master" Inherits="DetectorInspector.Views.ViewPage<DetectorInspector.Areas.ServiceSheet.ViewModels.ServiceSheetViewModel>" %>

<asp:Content ContentPlaceHolderID="InitContent" runat="server">
    <% 
        Page.Title = Html.GetCreateEditText(Model.Booking.Id) + " Service Sheet";
        
    %>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <h2><%=Page.Title %></h2>

    <%= Html.JQueryUIValidationSummary("Please correct the following errors before continuing: ", "edit-booking-form")%>


    <div class="ui-tabs ui-widget ui-widget-content ui-corner-all" id="tabs">
        <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
            <li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active"><a href="#details-tab">Details</a></li>
            <% if (!Model.IsCreate())
               { %>

            <%} %>
        </ul>

        <div class="ui-tabs-panel ui-widget-content ui-corner-bottom" id="booking">
            <% using (var form = Html.BeginForm("Edit", "Home", new { id = Model.ServiceSheet.Id, bookingId = Model.Booking.Id }, FormMethod.Post, new { id = "edit-service-sheet-form" }))
               { %>
            <%= Html.AntiForgeryToken() %>
            <%= Html.HiddenFor(model => model.ServiceSheet.RowVersion)%>
            <%= Html.Hidden("ServiceSheet.Technician.Id", Model.Booking.Technician!=null?Model.Booking.Technician.Id.ToString():string.Empty)%>
            <%= Html.Hidden("ServiceSheet.Date", StringFormatter.LocalDate(Model.Booking.Date))%>
            <% Html.RenderAction("Details", "Contact", new { area = "PropertyInfo", id = Model.Booking.PropertyInfo.Id }); %>
            <div class="left">
                <div class="row">
                    <%= Html.LabelFor(model => model.Booking.Technician)%>
                    <span class="read-only"><%=Model.Booking.Technician!=null?Model.Booking.Technician.Name:string.Empty %></span>
                </div>
                <div class="row">
                    <%= Html.LabelFor(model => model.Booking.Date)%>
                    <span class="read-only"><%=StringFormatter.LocalDate(Model.Booking.Date)%></span>
                </div>

            </div>
            <div class="right">
                <div class="row">
                    <%= Html.LabelFor(model => model.Booking.Time)%>
                    <span class="read-only"><%=StringFormatter.LocalTime(Model.Booking.Time)%></span>
                </div>
                <div class="row">
                    <%= Html.LabelFor(model => model.Booking.Duration)%>
                    <span class="read-only"><%=Model.Booking.Duration%> minutes</span>
                </div>
                <div class="row">
                    <%= Html.LabelFor(model => model.ServiceSheet.Discount)%>
                    <%= Html.TextBox("ServiceSheet.Discount", string.Format("{0:f2}", Model.ServiceSheet.Discount), new { @class = "small textbox money" })%>
                </div>
            </div>
            <div class="clear spacer"></div>
            <fieldset style="width: 847px;">
                <div class="widget service-sheet-item" id="service-sheet-item">
                    <% Html.RenderPartial("EditServiceSheetItem"); %>
                </div>
            </fieldset>
            <div class="clear"></div>
            <div class="left">
                <%=Html.Image("sticker", "~/Content/Images/signature.png", "Signature", "Signature", new { style = "padding: 0px 2px 0px 2px" })%>
                <%=Html.Image("sticker", "~/Content/Images/card.png", "Card Left", "Card Left", new { style = "padding: 0px 2px 0px 2px" })%>
                <%=Html.Image("sticker", "~/Content/Images/tick.png", "Completed", "Completed", new { style = "padding: 0px 2px 0px 2px" })%>
                <div class="clear"></div>
                <% if (Model.Booking.Technician != null)
                   { %>

                <%= Html.CheckBoxFor(model=> model.ServiceSheet.HasSignature)%>
                <%= Html.CheckBoxFor(model=> model.ServiceSheet.IsCardLeft)%>
                <%= Html.CheckBoxFor(model=> model.ServiceSheet.IsCompleted)%>

                <%} %>
            </div>
            <div class="right">
                <div class="buttons">
                    <input type="button" name="CloneButton" value="Clone" class="button ui-corner-all ui-state-default " onclick="javascript:saveServiceSheetItems(<%=Model.ServiceSheet.Id %>);editServiceSheetItem(true);return false;" />
                    <input type="button" name="AddButton" value="Add" class="button ui-corner-all ui-state-default " onclick="javascript:saveServiceSheetItems(<%=Model.ServiceSheet.Id %>);editServiceSheetItem(false);return false;" />
                    <input type="submit" id="saveButton" name="SaveButton" value="Save &amp; Close" class="button ui-corner-all ui-state-default " />
                    <input type="button" onclick="javascript:window.close()" value="Cancel" class="button ui-corner-all ui-state-default " />
                </div>
            </div>
            <div class="clear"></div>
            <div class="left">
                <fieldset class="narrow">
                    <legend>Problems</legend>
                    <div class="row">
                        <%= Html.LabelFor(model => model.ServiceSheet.HasProblem)%>
                        <%= Html.DropDownListFor(model => model.ServiceSheet.HasProblem, Html.GetYesNoSelectListItems(), new { @class = "narrow" })%>
                    </div>
                    <div class="row">
                        <%= Html.LabelFor(model => model.ServiceSheet.ProblemNotes)%>
                        <%= Html.TextAreaFor(model => model.ServiceSheet.ProblemNotes, new { @class = "narrow" })%>
                    </div>
                </fieldset>
            </div>
            <div class="right">
                <fieldset class="narrow">
                    <legend>Electrical</legend>
                    <div class="row">
                        <%=Html.LabelFor(model=>Model.ServiceSheet.IsElectricianRequired) %>
                        <%= Html.DropDownListFor(model => Model.ServiceSheet.IsElectricianRequired, Html.GetYesNoSelectListItems(), new { @class = "narrow" })%>
                    </div>
                    <div class="row">
                        <%= Html.LabelFor(model => model.ServiceSheet.ElectricalNotes)%>
                        <%= Html.TextAreaFor(model => model.ServiceSheet.ElectricalNotes, new { @class="narrow" })%>
                    </div>
                </fieldset>
 
            </div>
            <div class="clear"></div>
            <div class="fullwidth row">
                <fieldset style="width: 842px;">
                    <legend>Service Notes</legend>
                    <div class="row">
                        <%= Html.TextAreaFor(model => model.ServiceSheet.Notes, new{ style= "width: 810px;" })%>
                    </div>
                </fieldset>
            </div>
            <div class="clear"></div>
            <div class="left">
                <div class="buttons">
                    <input type="button" name="CloneButton" value="Show Thumbnail" class="button ui-corner-all ui-state-default " onclick="javascript:GetThumbnails(<%=Model.ServiceSheet.Id %>);return false;" /></div>
            </div>
            <div class="clear"></div>
            <%--this div to show images which are sent by android phone--%>
            <div id="Thumbnail"></div>

            <div class="clear"></div>
            <% } %>
            <div id="BigImagewithDetail" style="display: none"></div>
        </div>
    </div>
    <input type="hidden" id="h_serviceSheetId" />
    <%//rjc changed name of existing dialog %>
    <div id="confirmNotCompletedDialog" style="display: none;">Please confirm that you would like to proceed without marking this job as <b>"Completed"</b>.</div>
    <%//rjc . Added new dialog %>
    <div id="confirmChangesdDialog" style="display: none;">By resubmitting this service sheet you will be updating its status. Are you sure you would like to continue?</div>

    <script type="text/javascript">

        $().ready(function () {				   
            var confirmNotCompletedDialog = $('#confirmNotCompletedDialog');
            confirmNotCompletedDialog.dialog({
                width: 300,
                height: 100,
                title: 'Confirm service sheet is not completed',
                buttons: {
                    "Confirm": function() {
                        $(this).dialog('close');
                        saveServiceSheetItems(<%=Model.ServiceSheet.Id %>);
                        $('#edit-service-sheet-form').submit();
                    },
                    "Cancel": function() {
                        $(this).dialog('close');
                    }
                },
                autoOpen: false
            });

            var confirmChangesdDialog = $('#confirmChangesdDialog');

            confirmChangesdDialog.dialog({
                width: 300,
                height: 100,
                title: 'Warning Service sheet has been completed',
                buttons: {
                    "Confirm": function() {
                        $(this).dialog('close');
                        saveServiceSheetItems(<%=Model.ServiceSheet.Id %>);
                        $('#edit-service-sheet-form').submit();
                    },
                    "Cancel": function() {
                        $(this).dialog('close');
                    }
                },
                autoOpen: false
            });



            $('#saveButton').click(function(e) 
            {
                e.preventDefault();
                var itemCount = $('#ServiceSheetItem_Count').val();
                var hasProblemCount=0;
                for (var i = 0; i < itemCount; i++)
                {
                    if ( $('#ServiceSheetItem_HasProblem_' + i).is(':checked'))
                    {
                        hasProblemCount++;
                        break; // only need to find the first problem
                    }
                }
                if (hasProblemCount!=0)
                {
                    // alert("There is a 240 problem");
                    $("#ServiceSheet_IsElectricianRequired").val("Yes");
                }

                var completedInput = $('#ServiceSheet_IsCompleted');
						
                if (completedInput.length) {
                    if (completedInput.is(':checked'))
                    {                          
							   <% // rjc added code to check is the status was already completed (when the page loaded) and take appropriate action when they attempt to save and close 
        if (Model.ServiceSheet.IsCompleted == true)
        { %>
                        confirmChangesdDialog.dialog('open');
                        confirmChangesdDialog.height('auto'); // rjc adjust height of box to fit the text (fixes annoying bug)  
								<% }
        else
        { %>
                        //save items
                        saveServiceSheetItems(<%=Model.ServiceSheet.Id %>);
                        $('#edit-service-sheet-form').submit();
								<% } %>
                    } 
                    else
                    {
                        confirmNotCompletedDialog.dialog('open');
                        confirmNotCompletedDialog.height('auto'); // rjc adjust height of box to fit the text (fixes annoying bug)     
								
                    }    
                }
            });

            //init('#booking');
        });


        function editServiceSheetItem(isClone) {
            $.ajax({
                type: 'GET',
                url: '<%= Url.Action("EditServiceSheetItem", "Home", new { bookingId = Model.Booking.Id, isClone="_CLONE_"  }) %>'.replace(/_CLONE_/g, isClone),
                success: function (result) {
                    loadServiceSheet(result);
                }
            });
        }

        function loadServiceSheet(result) {

            var editDialog = $('#service-sheet-item');
            editDialog.html(result);

            editDialog.dialog('option', 'buttons',
            {
                'Cancel': function () {
                    $(this).dialog('close');
                }
            });

            init('#service-sheet-item');
        }

        function saveServiceSheetItems() {
            var itemCount = $('#ServiceSheetItem_Count').val();

            for (var i = 0; i < itemCount; i++) {
                var itemId = $('#ServiceSheetItem_Id_' + i).val();
                var itemLocation = $('#ServiceSheetItem_Location_' + i).val();
                var itemDetectorTypeId = $('#ServiceSheetItem_DetectorType_Id_' + i).val();
                var itemManufacturer = $('#ServiceSheetItem_Manufacturer_' + i).val();
                var itemExpiryYear = $('#ServiceSheetItem_ExpiryYear_' + i).val();
                var itemNewExpiryYear = $('#ServiceSheetItem_NewExpiryYear_' + i).val();
                var itemIsBatteryReplaced = $('#ServiceSheetItem_IsBatteryReplaced_' + i).is(':checked');
                var itemIsReplacedByElectrician = $('#ServiceSheetItem_IsReplacedByElectrician_' + i).is(':checked');
                var itemIsRepositioned = $('#ServiceSheetItem_IsRepositioned_' + i).is(':checked');
                var itemIsCleaned = $('#ServiceSheetItem_IsCleaned_' + i).is(':checked');
                var itemHasSticker = $('#ServiceSheetItem_HasSticker_' + i).is(':checked');
                var itemIsRequiredForCompliance = $('#ServiceSheetItem_IsRequiredForCompliance_' + i).is(':checked');
                var itemIsDecibelTested = $('#ServiceSheetItem_IsDecibelTested_' + i).is(':checked');
                var itemIsOptional = $('#ServiceSheetItem_IsOptional_' + i).is(':checked');
                var itemHasProblem = $('#ServiceSheetItem_HasProblem_' + i).is(':checked');
                $.ajax({
                    url: '<%= Url.Action("EditServiceSheetItem", "Home") %>',
                    dataType: 'json',
                    data: {
                        serviceSheetId: <%=Model.ServiceSheet.Id %>,
                        id: itemId,
                        location: itemLocation,
                        detectorTypeId: itemDetectorTypeId,
                        manufacturer: itemManufacturer,
                        expiryYear: itemExpiryYear,
                        newExpiryYear: itemNewExpiryYear,
                        isBatteryReplaced: itemIsBatteryReplaced,
                        isReplacedByElectrician: itemIsReplacedByElectrician,
                        isRepositioned: itemIsRepositioned,
                        isCleaned: itemIsCleaned,
                        hasSticker: itemHasSticker,
                        isRequiredForCompliance: itemIsRequiredForCompliance,
                        isDecibelTested: itemIsDecibelTested,
                        isOptional: itemIsOptional,
                        hasProblem: itemHasProblem
                    },
                    success: function (result) {

                    }
                });
            }
        };

        function deleteServiceSheetItem(id, name, rowVersion) {

            var deleteDialog = $('<div id="delete-service-sheet-item-dialog" style="display:none;" title="Delete Item"><p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Are you sure you wish to delete &quot;' + unescape(name) + '&quot;. Continue?</p></div>');
            deleteDialog.dialog({
                height: 230
            });
            deleteDialog.dialog('option', 'buttons',
            {
                'No': function () {
                    $(this).dialog('close');
                },
                'Yes': function () {
                    $(this).dialog('close');

                    var rowVersionHidden = $('#ServiceSheetItem_RowVersion')[0];

                    rowVersionHidden.value = rowVersion;

                    var form = $('#delete-service-sheet-item-form')[0];

                    form.action = '<%= Url.Action("DeleteServiceSheetItem", "Home", new { id="_ID_", bookingId = Model.Booking.Id }) %>'.replace(/_ID_/g, id);
                    form.submit();
                }
            });

            deleteDialog.dialog('open');
        };

        function ShowBigImageWithDetail(path) {
            $("#BigImagewithDetail").dialog({
                title: 'Image With Location And Date Time',
                autoOpen: true,
                resizable: true,
                height: 500,
                width: 500,
                show: { effect: 'drop', direction: "down" },
                modal: true,
                draggable: true,
                collapsible: true,
                minimizable: true,
                maximizable: true,
                buttons: {
                    "Previous": function() {
                        var elms = document.getElementById("ThumbnailInner").getElementsByTagName("img");
                        for (var i = 0; i < elms.length; i++) {
                            if (elms[i].id === $("#BigImagewithDetail").children()[0].id) {
                                if (i >=0)
                                    $("#BigImagewithDetail").html("<img id="+ elms[parseInt(i) - 1].id  +"  src=" + elms[parseInt(i) - 1].src + " width=98% height=98% > ");
                                break;
                            }
                        }
                    },
                    "Next": function() {
                        var elms = document.getElementById("ThumbnailInner").getElementsByTagName("img");
                        for (var i = 0; i < elms.length; i++) {
                            if (elms[i].id === $("#BigImagewithDetail").children()[0].id) {
                                if (i <= elms.length)
                                    $("#BigImagewithDetail").html("<img id="+ elms[parseInt(i) + 1].id  +"  src=" + elms[parseInt(i) + 1].src + " width=98% height=98% > ");
                                break;
                            }
                        }
                    }
                },
                open: function (event, ui) {
                    $("#BigImagewithDetail").html("<img id="+ path.id +" src=" + path.src + " width=98% height=98% > ");
                },
                close: function (event, ui) {
                }
            });
               
        }

       
        function GetThumbnails(id) {
            debugger;
            $("#h_serviceSheetId").val(id);
            $.ajax({
                type:'POST',
                dataType: 'json',
                //url: 'http://50.23.221.50<%= Url.Action("GetThumbnails") %>',  
                 url: '<%= Url.Action("GetThumbnails") %>',  
                data:{'id': $("#h_serviceSheetId").val()},
                success: function (result) {                    
                    $("#Thumbnail").html('').append(result);
                },
                error: function(error)
                {
                    alert(error);
                }
            });
        }
        //http://50.23.221.50
    </script>
</asp:Content>


