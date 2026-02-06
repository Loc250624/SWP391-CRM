<%-- 
    Document   : campaignList.jsp
    Created on : Feb 5, 2026, 2:09:31 PM
    Author     : phamv
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
        <link rel='stylesheet' href='${pageContext.request.contextPath}/style/campaign-list.css'>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <title>JSP Page</title>

    </head>
    <body>
        <div class="container-fluid px-0">
            <div class="row ">
                <div class="col-md-2 dashboardroute">
                    <div class="row ms-2">
                        <div class="col-md-4  " style="border-radius: 5px; background-color: #0095ce">
                            <span class="bi bi-mortarboard text-white"  style="font-size: 48px"></span>
                        </div>
                        <div class="col-md-7">
                            <div style="font-size: 24px"><h3>EzyEdu</h3></div> 
                            <div style="font-size: 14px">CRM Dashboard</div>
                        </div>
                    </div>
                    <ul class="nav" style="flex-direction: column" >
                        <li class="nav-item">
                            <a class="nav-link "  href="campaign-list.jsp">Campaign list</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" aria-current="page"href="lead-list.jsp">Lead list</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">Link</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link " >Disabled</a>
                        </li>
                    </ul>
                </div>
                <div class="col-md-10 ">
                    <h1 class="text-center">Campaign</h1>
                    <div class="text-end">
                        <button class="btn btn-success"
                                data-bs-toggle="modal"
                                data-bs-target="#createcampaign">+ Create new
                        </button>
                    </div>
                    <div class="d-flex my-2 justify-content-between">
                        <div class="d-flex">
                            <div>
                                <label>From</label>
                                <input type="date" class="form-control"/>
                            </div>
                            <div>
                                <label>To</label>
                                <input type="date" class="form-control"/>
                            </div>
                        </div>                      
                        <div >
                            <label>Budget range</label>
                            <div class="d-flex">
                                <div class="d-flex"> From: <input type="number" class="form-control"/></div>
                                <div class="d-flex"> To: <input type="number" class="form-control"/></div>     
                            </div>                           
                        </div>
                        <div>
                            <label>Search name:</label>
                            <input type="text" class="form-control"/>     
                        </div>    

                    </div>



                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Id</th>
                                <th>Name</th>
                                <th>Start date</th>
                                <th>End date</th>
                                <th>Action</th>        
                            </tr>                        
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td>
                                    <button class="btn btn-primary"
                                            data-bs-toggle="modal"
                                            data-bs-target="#campaigndetail"><i class="bi bi-eye"></i>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="d-flex justify-content-between">
                        <div class="d-flex">

                            Showing  <select class="form-select" style="width: 70px">
                                <option>5</option>
                            </select>  per entries


                        </div>
                        <div>
                            <nav aria-label="Page navigation example">
                                <ul class="pagination">
                                    <li class="page-item"><a class="page-link" href="#">Previous</a></li>
                                    <li class="page-item"><a class="page-link" href="#">...</a></li>
                                    <li class="page-item"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item"><a class="page-link" href="#">...</a></li>
                                    <li class="page-item"><a class="page-link" href="#">Next</a></li>
                                </ul>
                            </nav>     
                        </div>   
                    </div>          
                </div>
            </div>
        </div>


        <div class="modal fade" id="campaigndetail" >
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Campaign name</h5>
                        <button class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input class="form-control" placeholder="Campaign name">
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="createcampaign" >
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Campaign name</h5>
                        <button class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input class="form-control" placeholder="Campaign name">
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
