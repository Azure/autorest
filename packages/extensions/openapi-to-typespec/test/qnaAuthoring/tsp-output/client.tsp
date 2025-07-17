import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";


using Azure.ClientGenerator.Core;
using MicrosoftCognitiveLanguageServiceQuestionAnsweringAuthoring;









@@clientLocation(QuestionAnsweringProjectsOperationGroup.listProjects, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.listProjects, "ListProjects")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.getProjectDetails, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.getProjectDetails, "GetProjectDetails")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.createProject, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.createProject, "CreateProject")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.deleteProject, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.deleteProject, "DeleteProject")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.getDeleteStatus, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.getDeleteStatus, "GetDeleteStatus")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.export, "QuestionAnsweringProjects")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.getExportStatus, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.getExportStatus, "GetExportStatus")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.import, "QuestionAnsweringProjects")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.getImportStatus, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.getImportStatus, "GetImportStatus")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.deployProject, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.deployProject, "DeployProject")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.getDeployStatus, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.getDeployStatus, "GetDeployStatus")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.listDeployments, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.listDeployments, "ListDeployments")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.getSynonyms, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.getSynonyms, "GetSynonyms")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.updateSynonyms, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.updateSynonyms, "UpdateSynonyms")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.getSources, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.getSources, "GetSources")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.updateSources, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.updateSources, "UpdateSources")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.getUpdateSourcesStatus, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.getUpdateSourcesStatus, "GetUpdateSourcesStatus")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.getQnas, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.getQnas, "GetQnas")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.updateQnas, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.updateQnas, "UpdateQnas")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.getUpdateQnasStatus, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.getUpdateQnasStatus, "GetUpdateQnasStatus")
@@clientLocation(QuestionAnsweringProjectsOperationGroup.addFeedback, "QuestionAnsweringProjects")
@@clientName(QuestionAnsweringProjectsOperationGroup.addFeedback, "AddFeedback")


